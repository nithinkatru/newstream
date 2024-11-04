// lib/models/dashboard_response.dart

import 'video.dart';

class DashboardResponse {
  final List<Video> videos;
  final int nextPage;
  final bool hasMore;

  DashboardResponse({
    required this.videos,
    required this.nextPage,
    required this.hasMore,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    var videosJson = json['videos'] as List;
    List<Video> videosList = videosJson.map((video) => Video.fromJson(video)).toList();

    return DashboardResponse(
      videos: videosList,
      nextPage: json['nextPage'],
      hasMore: json['hasMore'],
    );
  }
}
