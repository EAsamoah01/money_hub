import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../config/app_config.dart';

/// app_settings key for the "require unlock" setting.
const kAppLockKey = 'app_lock';

/// Loaded in main(); changed from Settings → App lock.
final appLockEnabledProvider = StateProvider<bool>((ref) => false);

/// Fingerprint / face / device PIN check.
class AppLockService {
  final _auth = LocalAuthentication();

  /// Whether this device can lock the app at all.
  Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Shows the system prompt. Falls back to the device PIN if needed.
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock ${AppConfig.appName}',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
      );
    } catch (e) {
      debugPrint('App lock error: $e');
      return false;
    }
  }
}

final appLockServiceProvider = Provider((ref) => AppLockService());

/// Covers the whole app with a lock screen when the lock is on: at launch,
/// and after the app has been in the background for [relockAfter].
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});
  final Widget child;

  static const relockAfter = Duration(seconds: 30);

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> with WidgetsBindingObserver {
  late bool _locked = ref.read(appLockEnabledProvider);
  bool _authenticating = false;
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_locked) WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The fingerprint prompt itself pauses the app, so ignore that.
    if (_authenticating) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final away = _backgroundedAt;
      _backgroundedAt = null;
      if (ref.read(appLockEnabledProvider) &&
          away != null &&
          DateTime.now().difference(away) >= AppLockGate.relockAfter) {
        setState(() => _locked = true);
        _unlock();
      }
    }
  }

  Future<void> _unlock() async {
    if (_authenticating || !mounted) return;
    _authenticating = true;
    final ok = await ref.read(appLockServiceProvider).authenticate();
    _authenticating = false;
    if (ok && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    // Turning the lock off in Settings removes the cover immediately.
    final enabled = ref.watch(appLockEnabledProvider);
    final showLock = enabled && _locked;
    return Stack(
      children: [
        widget.child,
        if (showLock) Positioned.fill(child: _LockScreen(onUnlock: _unlock)),
      ],
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.onUnlock});
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.primary,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset('assets/branding/icon.png', width: 96, height: 96),
                ),
                const SizedBox(height: 20),
                Text(
                  '${AppConfig.appName} is locked',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: cs.onPrimary),
                ),
                const SizedBox(height: 24),
                FilledButton.tonalIcon(
                  onPressed: onUnlock,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Unlock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
