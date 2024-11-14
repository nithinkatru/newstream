// lib/screens/search_page.dart

import 'package:flutter/material.dart';
import '../models/video.dart';
import '../widgets/video_card.dart';
import 'video_player_page.dart' as player;

class SearchPage extends StatefulWidget {
  final String query;

  SearchPage({required this.query});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Video> _searchResults = [];
  bool _isLoading = false;

  // Define dummyVideos here
  final List<Video> dummyVideos = [
    Video(
      videoId: '1',
      title: 'Dummy Video 1',
      channelId: 'channel_1',
      channelName: 'Sample Channel 1',
      views: '1K',
      publishedAt: '2024-11-02',
      thumbnail: 'https://picsum.photos/seed/video1/400/225',
      videoUrl: 'https://pixabay.com/videos/download/video-27821_medium.mp4',
      description: 'A sample video for demonstration purposes.',
    ),
    Video(
      videoId: '2',
      title: 'Dummy Video 2',
      channelId: 'channel_2',
      channelName: 'Sample Channel 2',
      views: '2K',
      publishedAt: '2024-11-03',
      thumbnail: 'https://picsum.photos/seed/video2/400/225',
      videoUrl: 'https://pixabay.com/videos/download/video-15554_medium.mp4',
      description: 'Another sample video for demonstration.',
    ),
    Video(
      videoId: '3',
      title: 'Dummy Video 3',
      channelId: 'channel_3',
      channelName: 'Sample Channel 3',
      views: '3K',
      publishedAt: '2024-11-04',
      thumbnail: 'https://picsum.photos/seed/video3/400/225',
      videoUrl: 'https://pixabay.com/videos/download/video-14275_medium.mp4',
      description: 'A third sample video for demo purposes.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String query = widget.query.toLowerCase();
      List<Video> results = dummyVideos.where((video) {
        return video.title.toLowerCase().contains(query) ||
            video.description.toLowerCase().contains(query) ||
            video.channelName.toLowerCase().contains(query);
      }).toList();

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Error: $message',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onVideoTap(Video video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => player.VideoPlayerPage(videoPath: video.videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Results for "${widget.query}"'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _searchResults.isEmpty
            ? Center(child: Text('No results found.'))
            : ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            Video video = _searchResults[index];
            return VideoCard(
              video: video,
              onTap: () => _onVideoTap(video),
            );
          },
        ));
  }
}
