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
    return DashboardResponse(
      videos: (json['videos'] as List<dynamic>?)
          ?.map((videoJson) => Video.fromJson(videoJson))
          .toList() ??
          [],
      nextPage: json['nextPage'] ?? 1,
      hasMore: json['hasMore'] ?? false,
    );
  }
}
