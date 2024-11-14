// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/login_page.dart';
import '../screens/signup_page.dart';
import '../screens/watch_session_page.dart';
import '../screens/profile_page.dart';
import '../screens/video_upload_page.dart';
import '../screens/user_dashboard_page.dart';
import '../screens/video_player_page.dart';
import '../screens/search_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String watchSession = '/watchSession';
  static const String profile = '/profile';
  static const String videoUpload = '/videoUpload';
  static const String userDashboard = '/userDashboard';
  static const String videoPlayer = '/videoPlayer';
  static const String search = '/search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case watchSession:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => WatchSessionPage(sessionId: args['sessionId']));
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case videoUpload:
        return MaterialPageRoute(builder: (_) => VideoUploadPage());
      case userDashboard:
        return MaterialPageRoute(builder: (_) => UserDashboardPage());
      case videoPlayer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => VideoPlayerPage(videoPath: args['videoPath']));
      case search:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => SearchPage(query: args['query']));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}
