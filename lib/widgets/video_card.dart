// lib/widgets/video_card.dart

import 'package:flutter/material.dart';
import '../models/video.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;

  VideoCard({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // Video Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
              child: Image.network(
                video.thumbnail,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 90,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[700]),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 120,
                    height: 90,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            // Video Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      video.channelName,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          '${video.views} • ${video.publishedAt}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
