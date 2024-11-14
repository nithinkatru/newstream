// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';
import '../models/dashboard_response.dart';

class ApiService {
  static const String _baseUrl = 'https://api.nexstream.live'; // Replace with your actual API endpoint

  Future<DashboardResponse> fetchDashboard({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/dashboard?page=$page'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return DashboardResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }

// Add other API methods here as needed
}
