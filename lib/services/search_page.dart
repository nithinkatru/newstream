// lib/screens/search_page.dart

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/video.dart';
import '../../services/search_service.dart';
import '../../widgets/video_card.dart';
import '../screens/video_player_page.dart' as player;

class SearchPage extends StatefulWidget {
  final String query;

  SearchPage({required this.query});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService _searchService = SearchService();
  List<Video> _searchResults = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  String _currentQuery = '';
  final _debounce = PublishSubject<String>();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
    _loadSearchHistory();
    _fetchSearchResults();
    _scrollController.addListener(_scrollListener);

    _debounce.stream
        .distinct()
        .debounceTime(Duration(milliseconds: 500))
        .listen((query) {
      setState(() {
        _searchResults.clear();
        _currentPage = 1;
        _hasMore = true;
        _currentQuery = query;
      });
      _saveSearchHistory(query);
      _fetchSearchResults();
    });
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _debounce.add(widget.query);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchSearchResults();
    }
  }

  Future<void> _fetchSearchResults() async {
    if (!_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Video> fetchedVideos =
      await _searchService.searchVideos(_currentQuery, page: _currentPage);
      setState(() {
        _searchResults.addAll(fetchedVideos);
        _currentPage++;
        if (fetchedVideos.isEmpty) {
          _hasMore = false;
        }
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

  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.sublist(0, 10);
      }
    });
    await prefs.setStringList('searchHistory', _searchHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Results for "${widget.query}"'),
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Search History'),
                      content: _searchHistory.isEmpty
                          ? Text('No search history.')
                          : Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchHistory.length,
                          itemBuilder: (context, index) {
                            String pastQuery = _searchHistory[index];
                            return ListTile(
                              leading: Icon(Icons.history),
                              title: Text(pastQuery),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchPage(query: pastQuery),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: _searchResults.isEmpty
            ? _isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(child: Text('No results found.'))
            : ListView.builder(
          controller: _scrollController,
          itemCount: _searchResults.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _searchResults.length) {
              Video video = _searchResults[index];
              return VideoCard(
                video: video,
                onTap: () => _onVideoTap(video),
              );
            } else {
              // Show loading indicator at the bottom
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ));
  }
}
