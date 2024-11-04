import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'models/video.dart';
import 'models/dashboard_response.dart';
import 'services/api_service.dart';
import 'video_player_page.dart' as player;
import 'profile_page.dart';
import 'video_upload_page.dart' as upload;
import 'user_dashboard_page.dart';

enum BottomNavItem { Home, Library, Browse, Subscriptions, Dashboard }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BottomNavItem _currentNavItem = BottomNavItem.Home;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();

  // Data Variables
  List<Video> _videos = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  // Dummy Videos with dummy thumbnails from picsum.photos
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


  final List<String> categories = [
    'Movies',
    'TV Shows',
    'Live Streams',
    'New Releases',
    'Top Picks',
  ];

  final List<String> genres = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'Documentary',
  ];

  String subscriptionStatus = 'Premium';
  String renewalDate = '2024-12-31';

  String profileName = 'John Doe';
  String paymentMethod = 'Visa **** 1234';

  void _onNavItemTapped(int index) {
    setState(() {
      _currentNavItem = BottomNavItem.values[index];
    });
    if (_currentNavItem == BottomNavItem.Dashboard) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDashboardPage(),
        ),
      );
    }
  }

  void _showSnackBar(String title, String message, Color color, IconData icon) {
    Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: color,
      icon: Icon(
        icon,
        size: 28.0,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.white,
    )..show(context);
  }

  void _onVideoTap(Video video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => player.VideoPlayerPage(videoPath: video.videoUrl),
      ),
    );
  }

  void _onProfileTap() {
    final user = _auth.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, '/login');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }
  }

  void _onNotificationTap() {
    _showSnackBar(
      'Notifications',
      'No new notifications',
      Colors.blueAccent,
      FontAwesomeIcons.infoCircle,
    );
  }

  void _onCategoryTap(String category) {
    _showSnackBar(
      'Category Selected',
      'You selected "$category"',
      Colors.blueAccent,
      FontAwesomeIcons.tag,
    );
  }

  void _onManageSubscription() {
    _showSnackBar(
      'Manage Subscription',
      'Subscription management not implemented yet.',
      Colors.blueAccent,
      FontAwesomeIcons.infoCircle,
    );
  }

  void _onProfileInfo() {
    _showSnackBar(
      'Profile Info',
      'Edit profile functionality not implemented yet.',
      Colors.blueAccent,
      FontAwesomeIcons.infoCircle,
    );
  }

  void _onPaymentDetails() {
    _showSnackBar(
      'Payment Details',
      'Manage payment methods not implemented yet.',
      Colors.blueAccent,
      FontAwesomeIcons.infoCircle,
    );
  }

  void _onWatchHistory() {
    _showSnackBar(
      'Watch History',
      'View watch history functionality not implemented yet.',
      Colors.blueAccent,
      FontAwesomeIcons.infoCircle,
    );
  }

  void _onGenreTap(String genre) {
    _showSnackBar(
      'Genre Selected',
      'You selected "$genre" genre.',
      Colors.blueAccent,
      FontAwesomeIcons.tag,
    );
  }

  void _onPlaylistTap(String playlistTitle) {
    _showSnackBar(
      'Playlist Selected',
      'You selected "$playlistTitle"',
      Colors.green,
      FontAwesomeIcons.list,
    );
  }

  void _onUploadVideoTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => upload.VideoUploadPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      DashboardResponse response = await _apiService.fetchDashboard(page: _currentPage);
      setState(() {
        if (response.videos.isNotEmpty) {
          _videos.addAll(response.videos);
          _currentPage = response.nextPage;
          _hasMore = response.hasMore;
        } else {
          _videos = dummyVideos;
        }
      });
    } catch (e) {
      setState(() {
        _videos = dummyVideos;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.stream, color: Colors.blue, size: 32),
            SizedBox(width: 8),
            Text(
              'Nexstream',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.upload_file, color: Colors.black),
              onPressed: _onUploadVideoTap,
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.bell, color: Colors.black),
              onPressed: _onNotificationTap,
            ),
            // Updated the icon here
            IconButton(
              icon: FaIcon(FontAwesomeIcons.userCircle, color: Colors.black),
              onPressed: () => _onNavItemTapped(4),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildFeaturedSlider(),
              SizedBox(height: 20),
              _buildCategoryTabs(),
              SizedBox(height: 20),
              _buildSectionTitle('Recommendations'),
              _buildVideoList(_videos),
              SizedBox(height: 20),
              if (_hasMore)
                ElevatedButton(
                  onPressed: _fetchDashboardData,
                  child: _isLoading ? CircularProgressIndicator() : Text('Load More'),
                ),
              SizedBox(height: 20),
              _buildSubscriptionDetails(),
              SizedBox(height: 20),
              _buildAccountDetails(),
              SizedBox(height: 20),
              _buildSectionTitle('Browse Categories'),
              _buildGenresList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentNavItem.index,
        onTap: _onNavItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.book),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.images),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.tv),
            label: 'Subscriptions',
          ),
          // Updated the icon and label here
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userCircle),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for videos, movies, or series',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
        ),
        onSubmitted: (value) {
          _showSnackBar('Search', 'You searched for "$value"', Colors.blueAccent, FontAwesomeIcons.search);
        },
      ),
    );
  }

  Widget _buildFeaturedSlider() {
    if (_videos.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return CarouselSlider(
      options: CarouselOptions(height: 200.0, autoPlay: true, enlargeCenterPage: true),
      items: _videos.take(5).map((video) {
        return GestureDetector(
          onTap: () => _onVideoTap(video),
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(video.thumbnail),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  video.title,
                  style: TextStyle(color: Colors.white, fontSize: 16, backgroundColor: Colors.black45),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _onCategoryTap(categories[index]);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildVideoList(List<Video> videos) {
    if (videos.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          Video video = videos[index];
          return GestureDetector(
            onTap: () => _onVideoTap(video),
            child: Container(
              width: 150,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(video.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubscriptionDetails() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subscription Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.crown, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text('$subscriptionStatus', style: TextStyle(fontSize: 16)),
                Spacer(),
                TextButton(onPressed: _onManageSubscription, child: Text('Manage')),
              ],
            ),
            SizedBox(height: 8),
            Text('Renewal Date: $renewalDate', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            SizedBox(height: 16),
            Text('Special Offers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrangeAccent]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Upgrade to Premium & Get 1 Month Free!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.user, color: Colors.blueAccent),
              title: Text('Profile Info'),
              subtitle: Text(profileName),
              trailing: FaIcon(FontAwesomeIcons.arrowRight, size: 16),
              onTap: _onProfileInfo,
            ),
            Divider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.wallet, color: Colors.green),
              title: Text('Payment Details'),
              subtitle: Text(paymentMethod),
              trailing: FaIcon(FontAwesomeIcons.arrowRight, size: 16),
              onTap: _onPaymentDetails,
            ),
            Divider(),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.history, color: Colors.redAccent),
              title: Text('Watch History'),
              trailing: FaIcon(FontAwesomeIcons.arrowRight, size: 16),
              onTap: _onWatchHistory,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenresList() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _onGenreTap(genres[index]);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurpleAccent]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  genres[index],
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
