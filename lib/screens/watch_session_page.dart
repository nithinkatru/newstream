// lib/screens/watch_session_page.dart

import 'package:flutter/material.dart';

class WatchSessionPage extends StatelessWidget {
  final String sessionId;

  WatchSessionPage({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch Session'),
      ),
      body: Center(
        child: Text(
          'Watch Together Session ID: $sessionId',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
