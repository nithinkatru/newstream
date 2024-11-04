// lib/services/video_upload_service.dart

import 'dart:io';
import 'package:dio/dio.dart';

class VideoUploadService {
  final Dio _dio = Dio();

  Future<void> uploadVideo({
    required String filePath,
    required String title,
    required String description,
    required Function(int, int) onSendProgress,
  }) async {
    String uploadUrl = 'https://your-api-endpoint.com/upload';

    FormData formData = FormData.fromMap({
      'title': title,
      'description': description,
      'video': await MultipartFile.fromFile(filePath, filename: 'video.mp4'),
    });

    try {
      Response response = await _dio.post(
        uploadUrl,
        data: formData,
        onSendProgress: onSendProgress,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload video');
      }
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }
}
