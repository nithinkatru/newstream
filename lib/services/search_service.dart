// lib/services/search_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';

class SearchService {
  static const String _baseUrl = 'https://api.nexstream.live'; // Replace with your actual API endpoint

  Future<List<Video>> searchVideos(String query, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/search?query=$query&page=$page'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];
      return data.map((videoJson) => Video.fromJson(videoJson)).toList();
    } else {
      throw Exception('Failed to search videos');
    }
  }
}
