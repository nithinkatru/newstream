// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_response.dart';

class ApiService {
  static const String _baseUrl = 'https://api.nexstream.live';

  Future<DashboardResponse> fetchDashboard({int page = 0}) async {
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
}
