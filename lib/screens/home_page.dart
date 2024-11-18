// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/video.dart';
import 'video_player_page.dart' as player;
import 'profile_page.dart';
import 'video_upload_page.dart' as upload;
import 'user_dashboard_page.dart';
import '../widgets/video_card.dart';
import '../routes/app_routes.dart';
import 'search_page.dart'; // Import to access dummyVideos

enum BottomNavItem { Home, Library, Browse, Subscriptions, Dashboard }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BottomNavItem _currentNavItem = BottomNavItem.Home;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Data Variables
  List<Video> _videos = [];
  bool _isLoading = false;
  bool _hasMore = false;
  // Categories and Genres
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
    final snackBar = SnackBar(
      backgroundColor: color,
      duration: Duration(seconds: 3),
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              '$title: $message',
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

  void _onProfileTap() {
    final user = _auth.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, AppRoutes.login);
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
    setState(() {
      _isLoading = true;
    });

    try {

      setState(() {
        _videos = dummyVideos;
        _hasMore = false;
      });
    } catch (e) {
      _showSnackBar('Error', 'Failed to load videos.', Colors.red, Icons.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Updated dummyVideos with AWS S3 video links
  final List<Video> dummyVideos = [
    Video(
      videoId: '1',
      title: 'A Good Machine By Apple - Mac Mini M4 Real Test!',
      channelId: 'channel_1',
      channelName: 'Apple Reviews',
      views: '10K',
      publishedAt: '2024-11-18',
      thumbnail: 'https://picsum.photos/seed/video1/400/225',
      videoUrl: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/A%20Good%20Machine%20By%20Apple%20-%20Mac%20Mini%20M4%20Real%20Test%20%21.mp4?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJIMEYCIQD0tGZG%2BgQvxdxhG9aoO0io%2B2kJi2mLSCTwSY67uFT6VQIhAIAJfbVFdqVyXHffatIbaF7iTAOJJEqN%2F6W8xIlIyPLSKscDCGIQABoMODkxNjEyNTYxMDA2IgwpiEJs%2BVQpLb3yxFgqpAOMl2drEsh4W0oA7CRW%2Bo8CV72zb8FZXuYF2yoS65xEDwauqt5YZHMsIxG3Emzq8yndHz3wmDXB%2Fs0ohO2e7chPiVOaIJ1%2FacxkvqG1N3It4Pee4L%2BLYSXmiR3AzyVf7AWg76NlOKFbUEplueSFLvnB8%2F5ORahj1TrxGYlOLFUY45Sijwy1oRxt2l3BdVOqYG4az9Lr1NYQ1xhu%2BWuI%2F40wOL5T2Pzcb1x3i9GzvMQf2vyxN18oh%2Bc%2FxNj%2Fh%2B8JDDg6P5EBR0V0apCBEVNNuWowe3WwWbsTmSITe36A6TxBqlHpRzaKVxRcVPiGLoxtFZLudYeCvpBd1TMddPlGA4Q5rgTV%2BILUnp7qr6xv0jRstvMNeQxW%2BqBxBu2GXy5rn2M8mmgp5FM%2Bry%2B%2BxyYs69E9pwopebq5SziV568hlWwPeKw3owqqFtx4b0Qeoviwqy7phR6ebt03vbh4yWB3eXychQsVHaRDYDJ%2FmUjhNqCexs3v6Nd4YVUmC43WNnbunHvyHV8WScFTmzwUyYOv4Cz%2BCxRYDX4vEDy3yQFZcvRRlPFRhRowhu3suQY64wIoUe639kWbKikd%2BI9MJd8NdCzCnUY1gbBDQTcqaW8SroXS3O1muI5pwp2icRGzRP4cg2Z17KApI6xfqkxPpBehW9fiwyDGwNdZ9Ec7ujv7pozRkqv%2BLh7SajDfrwt3KqdAFALMeh2M9TIYPxErESIiy8Yy9KpoIazwj%2FsQPbV4IzI3L4I06R2fJfo608xvkj1cTv3eQUa1MqRJNXwCHERSHWvGn5XX91zTdL%2B675DF%2BkYf32tVEAG3CwrU0biHO4vttzLBek%2FGd6QLfRGOIjQkFPoVXwsQMqsZTavJkS86nbVyxVQINs2DbRnJcAUUIAn4Q9lQ2KdJNzCtPTbPyKO1OblSh9y%2Bx2N3E0GzhBsOqzkM0PxWmQE2jmT%2B0jwlRgKMpEZumvnzTKZ1bZKjYLnwHdY8Zx1G3ov1iUm%2BLO%2BERmldY6f4IL2NtE35t%2FgKQv3%2FLxXIAEu2SM8vLT9Q2S%2Ba2PQn&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXKHGCFVXI%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T162638Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=9b9e65e844fedb1b6fac7a1e2ca2f6f839d4da99295acfa82739420a92c35908',
      description: 'A sample video for demonstration purposes.',
    ),
    Video(
      videoId: '2',
      title: 'Apple Intelligence is for the Stupid Ones',
      channelId: 'channel_2',
      channelName: 'Tech Insights',
      views: '5K',
      publishedAt: '2024-11-18',
      thumbnail: 'https://picsum.photos/seed/video2/400/225',
      videoUrl: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/Apple%20Intelligence%20is%20for%20the%20Stupid%20Ones.mp4?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJIMEYCIQDqOOcVw68vg4bpDzLI9YrAPp5GpKRyS3y2RAyUHhCRWwIhAIgQvA2Ac3n1tyyfHg6KBInpgoywoBiIZUjHfc38me7cKscDCGIQABoMODkxNjEyNTYxMDA2IgxXh1JJQT3W%2BqGi8xkqpAN1mG3WacorNx%2FawvokLy99HjQhL5Rw1XWJZSK985R%2BWqX6RTwJLlQEic3iQJSIzygG2%2BaJLWbJ0FGhnbVXSDZRbD57ka9y7iCC1NbbdKH%2Ba9%2BwQS7e1GgYi0BJnJShfOLgBD8EhLAZmR7d54KlvdF%2BPVow8tf4CJpB0nD07m53osHOWmUG9RIRS9iQ33MgSUCEGBH3zG8QBGFT5d7oIFoyVcacVEN8iocGpEi6qgGmQ68TmOBoRo3zqy9n%2FLL3mhHz0zue6KQwB%2FY6YnkZbf%2BHJu9z4sre3YdJdrYUk7zmPHYqfCpeQoTVdfp3MvJ22ewEkawRchHDYbqubgitg%2By213qG8eXzthRqgRVzXBN06djVDbfODOlxkgAuJ9yHSj9pGuBUWQeE5GJFjAt00vKIwwzkhHmuqcfh3dq49ISeEA%2FNfo0LEBqCu4FsZWur1tQhnWK4%2FGfKvTVi5usovl1CGZzWQO2l6jEDyanSenoiFV0QwBWeP0nTu9HG3b2z9XjYrsVKz0fQ55ONEDoA%2Btc%2BeaktoBlTCNJwOvGc4%2F1Uw1TqrbQwhu3suQY64wLPMzCUu9oWStkKG4JyGbdStEsRygJ5gv1FSob6jPSh7ej9wnH2b1CKvSzy8hrqepkjQHGGm4wFp4GHqim3TZPoHbFKIi%2ByLwNhtL5ASd%2Fna%2FhjHFAfNTeOpyqlcDkhuLTHAeB9rF5POFUYAegfaskLKmGz9NZ%2FSepbHKrRAGvSTaC%2BZDgooJ5JDGpw3z%2FR2d6Q3kpkHw8wL1WOv%2BMJIy8PbSD9blC%2FAGEayjd7jSo6NIN6UJv%2BFoKzoVcS1w9Uc6M2ec2fGmBAq6c2MzEbJJEnyNzfum5bJyJsijKrjfb05lNI7XPcw6NTpuBgVhTD7X8FbhGil52%2BH20PZfSrJgtbrRE7HqfFfLl%2B0wp%2BZX8Iu3vzQ0MHaYQHNPpPxQaI8QoQGEEIBiFwYssxumJ3Pw8HFsPa8l84GOTRQsbNbzTFcwDRz6eRYIEByi%2FhinVgSO8hmd5%2BGNr55AQdsqPiy4rkKtQ4&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXFNPIQUY3%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T163919Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=3937e2abc378bc502116b236e10eeafb67821879c51d7b2a5a0bcff78a7901a5',
      description: 'Another sample video for demonstration.',
    ),
    Video(
      videoId: '3',
      title: 'Deadpool byebye',
      channelId: 'channel_2',
      channelName: 'Tech Insights',
      views: '5K',
      publishedAt: '2024-11-18',
      thumbnail: 'https://picsum.photos/seed/video2/400/225',
      videoUrl: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/Bye%20Bye%20Bye%20Opening%20Scene%20_%20DEADPOOL%20%26%20WOLVERINE%20%282024%29%20Movie%20CLIP%20HD.mp4?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJHMEUCIQDV3cO6FdNelvN5N67gjcrQI4G19RsvvxFZ8ffnPK32twIgHS1E0Df5sJxIRfnpWfezjEqwbtaxnpbO8M2%2FndSyBmYqxwMIYhAAGgw4OTE2MTI1NjEwMDYiDN2t3HWi4PQQame1FCqkA%2FfWasAzn68tplEFbyTXmfGbCQLB%2FmWI0riPNiQLZNGyMnRfjAb9JY%2BlqJM0aVe7FWft6iz3YFSwt6yR3eOXLJXoRMQVP4300Xtf%2Bud7wwHMSaSsyaaHvxHcK8jIMFvOK9%2BcLjnG7FZAfUKxMF5U8cggoFBmFPjTTDgjtdwv9coGmyREIHd05vfpv4uMofmhDT5BmJkQIPBw%2FyN9AGKKGmMIqIdNehAJOmQsszmOmBSa66W8t%2FOEEfg%2FyRuSyXZl0snKXeIUga3bCwLeFwu7IZEiF4Ek2RC8SQi%2FByZaH95oxcAUmjqwFtY1tHPCjvNHlTC9w7uxhJWsysqXaXdpi5yGp15zzSR6BMfudmSHMgXHVOmBBtKc5xL9y8rQHJ1rVCZXWPoX6Web2tg8MuUe1O0RNuFiXLZ6bZWQXu1zcDjks89eeRQtT3Getzf%2Fg2sMq1vEVfbemgCx4ctz0ANK5Df3zLGUNo3WxS1QMSH3jSNzfNEQun4SBptMhtuo7raQ4hC0WuynnNrbmQn00QI2vdyLCqy3Qu3rVw9Q8bS4AnqegBUoJzCG7ey5BjrkAtdLKaiCQRpWKmG8xWKTNtRVH7zCjLxAJGbRv%2Bh6tB2xXI0NoYY3yT12SPe11nHFKMNl8DL7So2k5bdsp6E%2Bajt7zYJorHgDYWJ2eB0IVrJGnQKC00qRq5LRqkMhWaNjo1DshNU0vV7fUditZ2RkMAe3FZAVVoOtq1KhjPKz3%2F1nQ22TKZ2rMXNucnI%2F1v%2Bm8yKpL1WjKlADBudi8gkvYDckmocd9yo4A2oDWgTdisRxWO20I%2FTdeTSQoeucbo6iqMrn31LrO6sNKOfsDhB4rGq3OqIH%2FT02LtN8U0lGA0qoA3PylvQWyC6maVIYE5WvICqXYP0AJoRJBg%2BDTy%2BbhFPdykfmc%2BBY0IxFzUroUh9WfCpv0pDMcZuCPm3TbDRlmLCGItXdqL0NZ7Zrr291RWvLGNvkZ7ko2T8Bx5gf7tPoOtZ6kAO%2B775GEKA44mD55Mzbi%2BK1RDmLxcnWmFj0m4aNQOxd&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXO75CEHYL%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T170251Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=9da970eb82955877a24d5a9c6d7af4bd30aec2d12c6767d5b55e3c79e187bfc5',
      description: 'Another sample video for demonstration.',
    ),
    Video(
      videoId: '4',
      title: 'Interstellar - Millers Planet (HDR - 4K - 5.1)',
      channelId: 'channel_2',
      channelName: 'Tech Insights',
      views: '5K',
      publishedAt: '2024-11-18',
      thumbnail: 'https://picsum.photos/seed/video2/400/225',
      videoUrl: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/Interstellar%20-%20Miller%27s%20Planet%20%28HDR%20-%204K%20-%205.1%29.mp4?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJHMEUCIQDV3cO6FdNelvN5N67gjcrQI4G19RsvvxFZ8ffnPK32twIgHS1E0Df5sJxIRfnpWfezjEqwbtaxnpbO8M2%2FndSyBmYqxwMIYhAAGgw4OTE2MTI1NjEwMDYiDN2t3HWi4PQQame1FCqkA%2FfWasAzn68tplEFbyTXmfGbCQLB%2FmWI0riPNiQLZNGyMnRfjAb9JY%2BlqJM0aVe7FWft6iz3YFSwt6yR3eOXLJXoRMQVP4300Xtf%2Bud7wwHMSaSsyaaHvxHcK8jIMFvOK9%2BcLjnG7FZAfUKxMF5U8cggoFBmFPjTTDgjtdwv9coGmyREIHd05vfpv4uMofmhDT5BmJkQIPBw%2FyN9AGKKGmMIqIdNehAJOmQsszmOmBSa66W8t%2FOEEfg%2FyRuSyXZl0snKXeIUga3bCwLeFwu7IZEiF4Ek2RC8SQi%2FByZaH95oxcAUmjqwFtY1tHPCjvNHlTC9w7uxhJWsysqXaXdpi5yGp15zzSR6BMfudmSHMgXHVOmBBtKc5xL9y8rQHJ1rVCZXWPoX6Web2tg8MuUe1O0RNuFiXLZ6bZWQXu1zcDjks89eeRQtT3Getzf%2Fg2sMq1vEVfbemgCx4ctz0ANK5Df3zLGUNo3WxS1QMSH3jSNzfNEQun4SBptMhtuo7raQ4hC0WuynnNrbmQn00QI2vdyLCqy3Qu3rVw9Q8bS4AnqegBUoJzCG7ey5BjrkAtdLKaiCQRpWKmG8xWKTNtRVH7zCjLxAJGbRv%2Bh6tB2xXI0NoYY3yT12SPe11nHFKMNl8DL7So2k5bdsp6E%2Bajt7zYJorHgDYWJ2eB0IVrJGnQKC00qRq5LRqkMhWaNjo1DshNU0vV7fUditZ2RkMAe3FZAVVoOtq1KhjPKz3%2F1nQ22TKZ2rMXNucnI%2F1v%2Bm8yKpL1WjKlADBudi8gkvYDckmocd9yo4A2oDWgTdisRxWO20I%2FTdeTSQoeucbo6iqMrn31LrO6sNKOfsDhB4rGq3OqIH%2FT02LtN8U0lGA0qoA3PylvQWyC6maVIYE5WvICqXYP0AJoRJBg%2BDTy%2BbhFPdykfmc%2BBY0IxFzUroUh9WfCpv0pDMcZuCPm3TbDRlmLCGItXdqL0NZ7Zrr291RWvLGNvkZ7ko2T8Bx5gf7tPoOtZ6kAO%2B775GEKA44mD55Mzbi%2BK1RDmLxcnWmFj0m4aNQOxd&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXO75CEHYL%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T170327Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=75116dd324a5a1c98302c4d68de53bbac9cca35c28032a91d1f728e85c97eca3',
      description: 'Another sample video for demonstration.',
    ),
    Video(
      videoId: '5',
      title: 'The Amateur _ Official',
      channelId: 'channel_2',
      channelName: 'Tech Insights',
      views: '5K',
      publishedAt: '2024-11-18',
      thumbnail: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/aithumbnail.jpg?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJHMEUCIEVmYmhQ%2FdattfvuPlvyF9ebE%2BeDelYeiDXtv4zEEQQaAiEAq0IVsfa7nJy0Z7pKmjqKlCmuWNAEqDY9VR90p1fftY8qxwMIZBAAGgw4OTE2MTI1NjEwMDYiDGObCN8IwHpcPvDE7iqkA9ZI%2B9vCvn%2B0PhchZEevyKCPk6kcLd%2F1CQcXQUDVXjcEs82Y9na5QBLYISyfOC21Rw1q367634zevvyNPThWVTo38HF2g7MmVcHy92CQGqBYN7TX4XhjJ0S7G1C5Pwow9x4Y10GlBteNBc98138Ictv4VCKOIQRTQXKgkMo5ZO0CllDsEmCf%2B0EYHukeI1NNLoG1kuTYSp5Af%2FSAMkRcPJ1FRlD6OA5hg%2F%2B200RBiVF7Cr9WRW9BWmjSBXiZi8EGUE5ihyGax3laNsX0mIiwUiH5gMPXczS%2FEWcMilN2mjOqPAYUXi5o6rAY4gftrYMeV%2BqXsqejY0LGf2BYqiQZNbv%2BOrfdEfOspBvmg5qnKxdMJVJCo2QFs9yIIqVfEYcADtZ%2FIAKYdQDIStHlUxf10oYzZ74LswyaQ5byMYrICNndDtreD6N0YQrjcStTzXbcbcctWt9qeiTvpIsah0tBrxVs%2BpItfuHYvjjeEgNifmflZ2ZHaGeLdY3rm9pgHrD%2Feg4rwE6Vf6sVn8RMA9IdQBB0u7gLMs65%2B11c16FlPcn2k7BLmjCG7ey5BjrkAlHUtsUPsvHdRnkzVprCQja5fcz3WcU1SU%2B2au11Dv3bsvdI%2FHX2NzVznfmrmlV%2Bq8OOGRzYTfj3BXIAfvhqsK21y0a4Sw425Bc8OdxXn84iv7VMFo%2B3xwR4xtUUNZh6%2FqXEFng0t2L%2FyCPOJ91hSKhJDuGIVLDU0EyMD2O%2Bt6YBsr0I0pTiA0HkhAsRsSWNzMSqJFJmcbLkvrzZ4%2BqTtSmTm2cPu5WUvpYPOGBdEwvoLIWFHoxz97Avafdhhcz8H%2F5w5F1MRfptHWemnbihDx%2FWqUZdEH9Ca8xbi92R7k%2F3bwlrf%2FDp%2FZndou6ILtZzeF2eRUCC3Q%2FyVi6Hs9UyvDJWuAgThMhfVsPU8eyoscCnWP4AIg1dJ81d79kcx%2Fs19fiEbZQWisqUdTuT%2F3RdbpFcnm5FJ0agsq2HJJVXyib%2FRHvzhhCxRR6ce%2FkFXAsVfWErXnX%2FNBBEyvdHptWKio32Jfg2&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXJOIVAEFU%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T182939Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=334f4bdcfc34c1850ba71579771e47bdaf512c14cc4857e7f0498b9c6452651e', // Update if you have specific thumbnails
      videoUrl: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/The%20Amateur%20_%20Official%20Trailer.mp4?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJHMEUCIQDV3cO6FdNelvN5N67gjcrQI4G19RsvvxFZ8ffnPK32twIgHS1E0Df5sJxIRfnpWfezjEqwbtaxnpbO8M2%2FndSyBmYqxwMIYhAAGgw4OTE2MTI1NjEwMDYiDN2t3HWi4PQQame1FCqkA%2FfWasAzn68tplEFbyTXmfGbCQLB%2FmWI0riPNiQLZNGyMnRfjAb9JY%2BlqJM0aVe7FWft6iz3YFSwt6yR3eOXLJXoRMQVP4300Xtf%2Bud7wwHMSaSsyaaHvxHcK8jIMFvOK9%2BcLjnG7FZAfUKxMF5U8cggoFBmFPjTTDgjtdwv9coGmyREIHd05vfpv4uMofmhDT5BmJkQIPBw%2FyN9AGKKGmMIqIdNehAJOmQsszmOmBSa66W8t%2FOEEfg%2FyRuSyXZl0snKXeIUga3bCwLeFwu7IZEiF4Ek2RC8SQi%2FByZaH95oxcAUmjqwFtY1tHPCjvNHlTC9w7uxhJWsysqXaXdpi5yGp15zzSR6BMfudmSHMgXHVOmBBtKc5xL9y8rQHJ1rVCZXWPoX6Web2tg8MuUe1O0RNuFiXLZ6bZWQXu1zcDjks89eeRQtT3Getzf%2Fg2sMq1vEVfbemgCx4ctz0ANK5Df3zLGUNo3WxS1QMSH3jSNzfNEQun4SBptMhtuo7raQ4hC0WuynnNrbmQn00QI2vdyLCqy3Qu3rVw9Q8bS4AnqegBUoJzCG7ey5BjrkAtdLKaiCQRpWKmG8xWKTNtRVH7zCjLxAJGbRv%2Bh6tB2xXI0NoYY3yT12SPe11nHFKMNl8DL7So2k5bdsp6E%2Bajt7zYJorHgDYWJ2eB0IVrJGnQKC00qRq5LRqkMhWaNjo1DshNU0vV7fUditZ2RkMAe3FZAVVoOtq1KhjPKz3%2F1nQ22TKZ2rMXNucnI%2F1v%2Bm8yKpL1WjKlADBudi8gkvYDckmocd9yo4A2oDWgTdisRxWO20I%2FTdeTSQoeucbo6iqMrn31LrO6sNKOfsDhB4rGq3OqIH%2FT02LtN8U0lGA0qoA3PylvQWyC6maVIYE5WvICqXYP0AJoRJBg%2BDTy%2BbhFPdykfmc%2BBY0IxFzUroUh9WfCpv0pDMcZuCPm3TbDRlmLCGItXdqL0NZ7Zrr291RWvLGNvkZ7ko2T8Bx5gf7tPoOtZ6kAO%2B775GEKA44mD55Mzbi%2BK1RDmLxcnWmFj0m4aNQOxd&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXO75CEHYL%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T170338Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=bee6e872139bab735ce2add0e113a018b743cd83b1fb3eb0446a8fb7728b0564',
      description: 'Another sample video for demonstration.',
    ),
    Video(
      videoId: '6',
      title: 'Tensions escalate as Biden makes bombshell Ukraine announcement and Putin approves nuclear weapons',
      channelId: 'channel_2',
      channelName: 'Tech Insights',
      views: '5K',
      publishedAt: '2024-11-18',
      thumbnail: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/aithumbnail.jpg?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJHMEUCIEVmYmhQ%2FdattfvuPlvyF9ebE%2BeDelYeiDXtv4zEEQQaAiEAq0IVsfa7nJy0Z7pKmjqKlCmuWNAEqDY9VR90p1fftY8qxwMIZBAAGgw4OTE2MTI1NjEwMDYiDGObCN8IwHpcPvDE7iqkA9ZI%2B9vCvn%2B0PhchZEevyKCPk6kcLd%2F1CQcXQUDVXjcEs82Y9na5QBLYISyfOC21Rw1q367634zevvyNPThWVTo38HF2g7MmVcHy92CQGqBYN7TX4XhjJ0S7G1C5Pwow9x4Y10GlBteNBc98138Ictv4VCKOIQRTQXKgkMo5ZO0CllDsEmCf%2B0EYHukeI1NNLoG1kuTYSp5Af%2FSAMkRcPJ1FRlD6OA5hg%2F%2B200RBiVF7Cr9WRW9BWmjSBXiZi8EGUE5ihyGax3laNsX0mIiwUiH5gMPXczS%2FEWcMilN2mjOqPAYUXi5o6rAY4gftrYMeV%2BqXsqejY0LGf2BYqiQZNbv%2BOrfdEfOspBvmg5qnKxdMJVJCo2QFs9yIIqVfEYcADtZ%2FIAKYdQDIStHlUxf10oYzZ74LswyaQ5byMYrICNndDtreD6N0YQrjcStTzXbcbcctWt9qeiTvpIsah0tBrxVs%2BpItfuHYvjjeEgNifmflZ2ZHaGeLdY3rm9pgHrD%2Feg4rwE6Vf6sVn8RMA9IdQBB0u7gLMs65%2B11c16FlPcn2k7BLmjCG7ey5BjrkAlHUtsUPsvHdRnkzVprCQja5fcz3WcU1SU%2B2au11Dv3bsvdI%2FHX2NzVznfmrmlV%2Bq8OOGRzYTfj3BXIAfvhqsK21y0a4Sw425Bc8OdxXn84iv7VMFo%2B3xwR4xtUUNZh6%2FqXEFng0t2L%2FyCPOJ91hSKhJDuGIVLDU0EyMD2O%2Bt6YBsr0I0pTiA0HkhAsRsSWNzMSqJFJmcbLkvrzZ4%2BqTtSmTm2cPu5WUvpYPOGBdEwvoLIWFHoxz97Avafdhhcz8H%2F5w5F1MRfptHWemnbihDx%2FWqUZdEH9Ca8xbi92R7k%2F3bwlrf%2FDp%2FZndou6ILtZzeF2eRUCC3Q%2FyVi6Hs9UyvDJWuAgThMhfVsPU8eyoscCnWP4AIg1dJ81d79kcx%2Fs19fiEbZQWisqUdTuT%2F3RdbpFcnm5FJ0agsq2HJJVXyib%2FRHvzhhCxRR6ce%2FkFXAsVfWErXnX%2FNBBEyvdHptWKio32Jfg2&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXJOIVAEFU%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T182939Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=334f4bdcfc34c1850ba71579771e47bdaf512c14cc4857e7f0498b9c6452651e', // Update if you have specific thumbnails
      videoUrl: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/Tensions%20escalate%20as%20Biden%20makes%20bombshell%20Ukraine%20announcement%20and%20Putin%20approves%20nuclear%20weapons.mp4?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJIMEYCIQDLDdJpdnedBtJjAe7pK6Mdzu59lFj1Eh0nqycmIWvbaQIhAOC8iqjzYjUy7BGrB1bdop%2Fh1%2BwW%2Bx4IF5WI7TMb07GOKscDCGQQABoMODkxNjEyNTYxMDA2Igxc1RtZPBWoV5ElcT0qpAMexBrx5CO08TdjFiVf611SttaWOiaQ%2Fwe4DAzt0%2Fb5HZVGwb7QtXf53iU0hv657rleWfxjYXmQ4Qn4Y3gIJUpXWphSXt3K2l2Y49VvwA3xQsl8Au2K4Z5WXOALk2vvzHc%2FpZ8YMtAJMbCQuImQWP5uXRQnw6cI6c5jyCMiD5Fq05ZlGr%2Fqt6sKEgUx%2FUbVlMxk0%2FX0w1iRrSpWfszNvFpgq7TRHhbfPpIhgLC4SEJAKvWqdTPgZA6YcN8nCavNqmaBWMkqNkj54Cf%2BO8uM2HHXCpEOuuR22LTbmKbjJcYJREhYGaXLV8KBJAOptJf8tzk1wLmKyudjqaD06rXQgbBS3Wa0JwMDrYo3DHBBc6D9sz3jZMbU9nG3rivQJM2rVwWfh9nwPJoinELbB6XI500PedfO%2BGAe508oeTPlaqPrz4pDgztGaDTYwhOfrNLO0mzvxB2gN8sBDkM5ynT6gpooXOBaZaEckqVpO1sFzGvyMuUmBRBR75BKN6pOSa7Wbe8RPkFAr3cKcJmR9dxJy%2Bj8rWj1hlOsex2TLQMDxvmxJzgK7Cowhu3suQY64wJHBkR5u19I%2F78uldf9pPyNfOZPluvGqcSMid7z%2FW2%2Fb70Tg2BxAE9A4BorQ2MWM8jvneNjIN%2FzK9ed8RurYJRpb%2BLenveNLrBgt8ZhtiBPZBHN8xuR5kVvounhIoWi8Et5lPonuMBSWvk84kyGQiC%2Boosur%2B8RemetdfC7YYekL%2F9Owu51EImRCzI6DUYwKp%2Br8xtJSp3hRr5NSVnv9GJhVhzbfR80DIFg61jjxP5C1ehMgxWekK874NTUAYCxHeyZrKg%2FKwZ6KwLIdCLEgmiNRq7Y4fJZTlId7BCxjNoSw4Xmr32kWIEgplPAML0eRfAXVbSsS3NC2UaRPkhvc6%2B1681w0YKsXW%2FE7zUJ1UmrEThQJwQlNi5FQTmLYpjYFof3ZhedL6ZYBoPTDcqNEHnElDPy%2BPTsBu%2B6weBQaaHQz5aVJz%2FBYXEN6v0UhuTwWW1eQAKh7d%2FNjyIb4ZuoSYANA4US&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXL4HSV34E%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T184308Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=3eec5b158235cdad33b17197ef8799e1ed4f4ccebfbf83971e800d08fc24e34b',
      description: 'Another sample video for demonstration.',
    ),
    Video(
      videoId: '7',
      title: 'I tested the Craziest Xiaomi Gadgets!',
      channelId: 'channel_2',
      channelName: 'Tech Insights',
      views: '5K',
      publishedAt: '2024-11-18',
      thumbnail: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/aithumbnail.jpg?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJHMEUCIEVmYmhQ%2FdattfvuPlvyF9ebE%2BeDelYeiDXtv4zEEQQaAiEAq0IVsfa7nJy0Z7pKmjqKlCmuWNAEqDY9VR90p1fftY8qxwMIZBAAGgw4OTE2MTI1NjEwMDYiDGObCN8IwHpcPvDE7iqkA9ZI%2B9vCvn%2B0PhchZEevyKCPk6kcLd%2F1CQcXQUDVXjcEs82Y9na5QBLYISyfOC21Rw1q367634zevvyNPThWVTo38HF2g7MmVcHy92CQGqBYN7TX4XhjJ0S7G1C5Pwow9x4Y10GlBteNBc98138Ictv4VCKOIQRTQXKgkMo5ZO0CllDsEmCf%2B0EYHukeI1NNLoG1kuTYSp5Af%2FSAMkRcPJ1FRlD6OA5hg%2F%2B200RBiVF7Cr9WRW9BWmjSBXiZi8EGUE5ihyGax3laNsX0mIiwUiH5gMPXczS%2FEWcMilN2mjOqPAYUXi5o6rAY4gftrYMeV%2BqXsqejY0LGf2BYqiQZNbv%2BOrfdEfOspBvmg5qnKxdMJVJCo2QFs9yIIqVfEYcADtZ%2FIAKYdQDIStHlUxf10oYzZ74LswyaQ5byMYrICNndDtreD6N0YQrjcStTzXbcbcctWt9qeiTvpIsah0tBrxVs%2BpItfuHYvjjeEgNifmflZ2ZHaGeLdY3rm9pgHrD%2Feg4rwE6Vf6sVn8RMA9IdQBB0u7gLMs65%2B11c16FlPcn2k7BLmjCG7ey5BjrkAlHUtsUPsvHdRnkzVprCQja5fcz3WcU1SU%2B2au11Dv3bsvdI%2FHX2NzVznfmrmlV%2Bq8OOGRzYTfj3BXIAfvhqsK21y0a4Sw425Bc8OdxXn84iv7VMFo%2B3xwR4xtUUNZh6%2FqXEFng0t2L%2FyCPOJ91hSKhJDuGIVLDU0EyMD2O%2Bt6YBsr0I0pTiA0HkhAsRsSWNzMSqJFJmcbLkvrzZ4%2BqTtSmTm2cPu5WUvpYPOGBdEwvoLIWFHoxz97Avafdhhcz8H%2F5w5F1MRfptHWemnbihDx%2FWqUZdEH9Ca8xbi92R7k%2F3bwlrf%2FDp%2FZndou6ILtZzeF2eRUCC3Q%2FyVi6Hs9UyvDJWuAgThMhfVsPU8eyoscCnWP4AIg1dJ81d79kcx%2Fs19fiEbZQWisqUdTuT%2F3RdbpFcnm5FJ0agsq2HJJVXyib%2FRHvzhhCxRR6ce%2FkFXAsVfWErXnX%2FNBBEyvdHptWKio32Jfg2&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXJOIVAEFU%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T182939Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=334f4bdcfc34c1850ba71579771e47bdaf512c14cc4857e7f0498b9c6452651e', // Update if you have specific thumbnails
      videoUrl: 'https://nextstreamappbucket.s3.us-east-2.amazonaws.com/I%20tested%20the%20Craziest%20Xiaomi%20Gadgets%21.mp4?response-content-disposition=inline&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEMv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJIMEYCIQDLDdJpdnedBtJjAe7pK6Mdzu59lFj1Eh0nqycmIWvbaQIhAOC8iqjzYjUy7BGrB1bdop%2Fh1%2BwW%2Bx4IF5WI7TMb07GOKscDCGQQABoMODkxNjEyNTYxMDA2Igxc1RtZPBWoV5ElcT0qpAMexBrx5CO08TdjFiVf611SttaWOiaQ%2Fwe4DAzt0%2Fb5HZVGwb7QtXf53iU0hv657rleWfxjYXmQ4Qn4Y3gIJUpXWphSXt3K2l2Y49VvwA3xQsl8Au2K4Z5WXOALk2vvzHc%2FpZ8YMtAJMbCQuImQWP5uXRQnw6cI6c5jyCMiD5Fq05ZlGr%2Fqt6sKEgUx%2FUbVlMxk0%2FX0w1iRrSpWfszNvFpgq7TRHhbfPpIhgLC4SEJAKvWqdTPgZA6YcN8nCavNqmaBWMkqNkj54Cf%2BO8uM2HHXCpEOuuR22LTbmKbjJcYJREhYGaXLV8KBJAOptJf8tzk1wLmKyudjqaD06rXQgbBS3Wa0JwMDrYo3DHBBc6D9sz3jZMbU9nG3rivQJM2rVwWfh9nwPJoinELbB6XI500PedfO%2BGAe508oeTPlaqPrz4pDgztGaDTYwhOfrNLO0mzvxB2gN8sBDkM5ynT6gpooXOBaZaEckqVpO1sFzGvyMuUmBRBR75BKN6pOSa7Wbe8RPkFAr3cKcJmR9dxJy%2Bj8rWj1hlOsex2TLQMDxvmxJzgK7Cowhu3suQY64wJHBkR5u19I%2F78uldf9pPyNfOZPluvGqcSMid7z%2FW2%2Fb70Tg2BxAE9A4BorQ2MWM8jvneNjIN%2FzK9ed8RurYJRpb%2BLenveNLrBgt8ZhtiBPZBHN8xuR5kVvounhIoWi8Et5lPonuMBSWvk84kyGQiC%2Boosur%2B8RemetdfC7YYekL%2F9Owu51EImRCzI6DUYwKp%2Br8xtJSp3hRr5NSVnv9GJhVhzbfR80DIFg61jjxP5C1ehMgxWekK874NTUAYCxHeyZrKg%2FKwZ6KwLIdCLEgmiNRq7Y4fJZTlId7BCxjNoSw4Xmr32kWIEgplPAML0eRfAXVbSsS3NC2UaRPkhvc6%2B1681w0YKsXW%2FE7zUJ1UmrEThQJwQlNi5FQTmLYpjYFof3ZhedL6ZYBoPTDcqNEHnElDPy%2BPTsBu%2B6weBQaaHQz5aVJz%2FBYXEN6v0UhuTwWW1eQAKh7d%2FNjyIb4ZuoSYANA4US&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA47GB77ZXL4HSV34E%2F20241118%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20241118T184556Z&X-Amz-Expires=43200&X-Amz-SignedHeaders=host&X-Amz-Signature=3e602caa5a31d78484b2e80bfabcd178d5d00e8663715def665cc924d5f9a350',
      description: 'Another sample video for demonstration.',
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            IconButton(
              icon: FaIcon(FontAwesomeIcons.userCircle, color: Colors.black),
              onPressed: () => _onNavItemTapped(4),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
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
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userCircle),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    TextEditingController _searchController = TextEditingController();

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for videos, movies, or series',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Navigator.pushNamed(
              context,
              AppRoutes.search,
              arguments: {'query': value.trim()},
            );
          } else {
            _showSnackBar(
              'Empty Search',
              'Please enter a search term.',
              Colors.orange,
              Icons.warning,
            );
          }
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

    // Make sure the ListView.builder's itemCount reflects the total number of videos
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,  // Use the length of the video list to ensure all are included
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        video.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.broken_image, color: Colors.grey[700], size: 50),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
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
