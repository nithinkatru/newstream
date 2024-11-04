// lib/models/video.dart

class Video {
  final String videoId;
  final String title;
  final String channelId;
  final String channelName;
  final String views;
  final String publishedAt;
  final String thumbnail;
  final String videoUrl;
  final String? description; // Add description as an optional property

  Video({
    required this.videoId,
    required this.title,
    required this.channelId,
    required this.channelName,
    required this.views,
    required this.publishedAt,
    required this.thumbnail,
    required this.videoUrl,
    this.description, // Use a comma here, not a semicolon
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoId: json['video_id'] ?? '', // Use null-aware operators to handle missing keys
      title: json['title'] ?? '',
      channelId: json['channel_id'] ?? '',
      channelName: json['channel_name'] ?? '',
      views: json['views'] ?? '0',
      publishedAt: json['published_at'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['video_url'] ?? '', // Ensure this key exists in the JSON
      description: json['description'] ?? '', // Correctly handle the description key
    );
  }
}
