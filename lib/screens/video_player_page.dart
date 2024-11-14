import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  VideoPlayerPage({required this.videoPath});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isBuffering = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {

      _controller = (kIsWeb || widget.videoPath.startsWith('http'))
          ? VideoPlayerController.network(widget.videoPath)
          : VideoPlayerController.file(File(widget.videoPath));

      await _controller.initialize();
      setState(() {
        _isBuffering = false;
        _controller.play();
      });
    } catch (error) {
      setState(() {
        _hasError = true;
        _isBuffering = false;
      });
      print("Error initializing video player: $error"); // Log error
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Video Player Error'),
        ),
        body: Center(
          child: Text('Failed to load video. Unsupported format or URL.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _isBuffering
            ? CircularProgressIndicator()
            : _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
