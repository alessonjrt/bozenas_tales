import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeThumb extends StatelessWidget {
  final String youtubeUrl;
  final double? thumbnailHeight;

  const YoutubeThumb({
    super.key,
    required this.youtubeUrl,
    this.thumbnailHeight,
  });

  String _extractVideoId(String url) {
    final uri = Uri.tryParse(url);

    if (uri != null && uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    } else if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    throw ArgumentError();
  }

  String _buildThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
  }

  void _launchYoutube(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final videoId = _extractVideoId(youtubeUrl);
      final thumbnailUrl = _buildThumbnailUrl(videoId);

      return GestureDetector(
        onTap: () => _launchYoutube(context, youtubeUrl),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                height: thumbnailHeight ?? 200.0,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: thumbnailHeight ?? 200.0,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ],
        ),
      );
    } catch (_) {
      return Container(
        width: double.infinity,
        height: thumbnailHeight ?? 200.0,
        color: Colors.grey,
      );
    }
  }
}
