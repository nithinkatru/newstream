import 'dart:async';
import 'dart:io';
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
  bool _controlsVisible = false;  // Start with controls hidden

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = (widget.videoPath.startsWith('http') || widget.videoPath.startsWith('https'))
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
      print("Error initializing video player: $error");
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
      body: MouseRegion(
        onEnter: (_) {
          _setControlsVisibility(true);
        },
        onExit: (_) {
          _setControlsVisibility(false);
        },
        child: Container(
          color: Colors.black, // Black background
          child: Center(
            child: _isBuffering
                ? CircularProgressIndicator()
                : _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_controller),
                  _buildControls(context),
                ],
              ),
            )
                : Container(),
          ),
        ),
      ),
    );
  }

  void _setControlsVisibility(bool visible) {
    setState(() {
      _controlsVisible = visible;
    });
  }

  Widget _buildControls(BuildContext context) {
    return AnimatedOpacity(
      opacity: _controlsVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: 50,
        color: Colors.black26,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.replay_10),
              color: Colors.white,
              onPressed: () {
                _controller.seekTo(
                  _controller.value.position - Duration(seconds: 10),
                );
              },
            ),
            IconButton(
              icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.forward_10),
              color: Colors.white,
              onPressed: () {
                _controller.seekTo(
                  _controller.value.position + Duration(seconds: 10),
                );
              },
            ),
            Expanded(
              child: VideoProgressIndicator(_controller, allowScrubbing: true),
            ),
            IconButton(
              icon: Icon(Icons.volume_up),
              color: Colors.white,
              onPressed: () {
                // Increment volume code here
              },
            ),
          ],
        ),
      ),
    );
  }
}
