import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Embedded YouTube player on web, Android, iOS and macOS.
/// Windows/Linux have no supported web view, so they show a thumbnail that
/// opens the video on YouTube instead.
class LessonVideo extends StatefulWidget {
  const LessonVideo({super.key, required this.videoId});
  final String videoId;

  @override
  State<LessonVideo> createState() => _LessonVideoState();
}

bool get _canEmbed =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

class _LessonVideoState extends State<LessonVideo> {
  YoutubePlayerController? _controller;

  Uri get _watchUrl => Uri.parse('https://www.youtube.com/watch?v=${widget.videoId}');

  @override
  void initState() {
    super.initState();
    if (_canEmbed) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: widget.videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  Future<void> _openOnYouTube() => launchUrl(_watchUrl, mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: c != null
              ? YoutubePlayer(controller: c, aspectRatio: 16 / 9)
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: InkWell(
                    onTap: _openOnYouTube,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://img.youtube.com/vi/${widget.videoId}/hqdefault.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: Colors.black87),
                        ),
                        const Center(
                          child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _openOnYouTube,
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Watch on YouTube'),
          ),
        ),
      ],
    );
  }
}
