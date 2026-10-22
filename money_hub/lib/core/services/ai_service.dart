import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'purchases_service.dart';

/// What the AI is being asked to do. Each mode has its own instructions on
/// the server (ai_worker/src/index.js).
enum AiMode { coach, insights, categorize, explain }

class AiMessage {
  const AiMessage({required this.fromUser, required this.text});
  final bool fromUser;
  final String text;

  Map<String, String> toJson() => {'role': fromUser ? 'user' : 'assistant', 'content': text};
}

enum AiFailure { notConfigured, notPro, limit, network, server }

class AiException implements Exception {
  const AiException(this.kind, this.message);
  final AiFailure kind;
  final String message;

  @override
  String toString() => message;
}

/// app_settings key: the user agreed to send budget data to the AI.
const kAiConsentKey = 'ai_consent';

/// Talks to the Money Core AI proxy. The Anthropic key never ships in the app.
class AiService {
  AiService(this._purchases, {http.Client? client}) : _client = client ?? http.Client();
  final PurchasesService _purchases;
  final http.Client _client;

  static bool get isConfigured => AppConfig.aiProxyUrl.isNotEmpty;

  Uri get _endpoint {
    var base = AppConfig.aiProxyUrl.trim();
    while (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    return Uri.parse('$base/ai');
  }

  Future<String> ask({
    required AiMode mode,
    required List<AiMessage> messages,
    String context = '',
  }) async {
    if (!isConfigured) {
      throw const AiException(
        AiFailure.notConfigured,
        'AI is not set up in this build yet. Add AI_PROXY_URL to env.json (see AI.md).',
      );
    }
    final userId = await _purchases.userId();
    final http.Response res;
    try {
      res = await _client
          .post(
            _endpoint,
            headers: {
              'Content-Type': 'application/json',
              'X-User-Id': userId,
              if (kDebugMode && AppConfig.aiDevToken.isNotEmpty) 'X-Dev-Token': AppConfig.aiDevToken,
            },
            body: jsonEncode({
              'mode': mode.name,
              'messages': [for (final m in messages) m.toJson()],
              'context': context,
            }),
          )
          .timeout(const Duration(seconds: 45));
    } on TimeoutException {
      throw const AiException(AiFailure.network, 'The AI took too long to answer. Try again.');
    } catch (_) {
      throw const AiException(AiFailure.network, 'No connection. Check your internet and try again.');
    }

    Map<String, dynamic> body = const {};
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}
    final error = body['error'] as String?;

    switch (res.statusCode) {
      case 200:
        final text = (body['text'] as String? ?? '').trim();
        if (text.isEmpty) throw const AiException(AiFailure.server, 'The AI sent an empty answer. Try again.');
        return text;
      case 402:
        throw AiException(AiFailure.notPro, error ?? 'AI features need Pro.');
      case 429:
        throw AiException(AiFailure.limit, error ?? "You've reached today's AI limit.");
      default:
        throw AiException(AiFailure.server, error ?? 'Something went wrong (${res.statusCode}). Try again.');
    }
  }
}

final aiServiceProvider = Provider<AiService>((ref) => AiService(ref.watch(purchasesServiceProvider)));
