import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../appeals_and_disputes_page.dart';
import '../admin_analytics_page.dart';

class UserDashboardPage extends StatelessWidget {

  final List<Map<String, dynamic>> videos = List.generate(5, (index) {
    return {
      'title': 'Video Title ${index + 1}',
      'views': '${(index * 1000 + 500)} views',
      'thumbnail':
      'https://picsum.photos/seed/${index + 1}/400/225',
    };
  });


  final List<Map<String, dynamic>> reportedVideos = List.generate(3, (index) {
    return {
      'title': 'Reported Video ${index + 1}',
      'reports': '${index + 2} reports',
      'thumbnail':
      'https://picsum.photos/seed/reported${index + 1}/400/225',
    };
  });


  final List<Map<String, dynamic>> underReviewVideos = List.generate(3, (index) {
    return {
      'title': 'Under Review Video ${index + 1}',
      'status': 'Under Review',
      'thumbnail':
      'https://picsum.photos/seed/underreview${index + 1}/400/225',
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.cast, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=65'),
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              _buildSectionTitle('Subscription Status'),
              SizedBox(height: 10),
              Card(
                color: Colors.redAccent,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.film, color: Colors.white),
                  title: Text('Premium Membership',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  subtitle: Text('Renewal Date: 2024-12-31',
                      style: TextStyle(color: Colors.white70)),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text('Manage', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: 20),


              _buildSectionTitle('Watch History'),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return _buildVideoCard(context, videos[index]);
                  },
                ),
              ),
              SizedBox(height: 20),

              // User Management Section
              _buildSectionTitle('User Management'),
              SizedBox(height: 10),
              // Admin Statistics Card with navigation to AdminAnalyticsPage
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.users, color: Colors.blue),
                  title: Text('Admin Statistics',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Overall based on category (Mobile Version)'),
                  trailing: TextButton(
                    onPressed: () {
                      // Navigate to AdminAnalyticsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAnalyticsPage(),
                        ),
                      );
                    },
                    child: Text('View Details'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Appeals & Disputes Section with updated styling
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.gavel, color: Colors.redAccent),
                  title: Text('Appeals & Disputes',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Manage your appeals and disputes'),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppealsAndDisputesPage(),
                        ),
                      );
                    },
                    child: Text('Open'),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Reported Videos Section with enhanced styling
              _buildSectionTitle('Reported Videos'),
              SizedBox(height: 10),
              _buildVideoList(context, reportedVideos, 'reports'),

              // Under Review Videos Section with enhanced styling
              SizedBox(height: 20),
              _buildSectionTitle('Under Review Videos'),
              SizedBox(height: 10),
              _buildVideoList(context, underReviewVideos, 'status'),

              // Statistics Section with updated styling
              SizedBox(height: 20),
              _buildSectionTitle('Statistics'),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatisticCard('Videos Uploaded', '25', Colors.blueAccent,
                        Icons.video_call),
                    _buildStatisticCard('Income Generated', '\$500', Colors.green,
                        Icons.attach_money),
                    _buildStatisticCard(
                        'Total Likes', '1200', Colors.orange, Icons.thumb_up),
                    _buildStatisticCard(
                        'Subscribers', '1.2K', Colors.purple, Icons.person_add),
                    _buildStatisticCard(
                        'Comments', '350', Colors.redAccent, Icons.comment),
                    _buildStatisticCard('Shares', '75', Colors.teal, Icons.share),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Recently Uploaded Videos Section with enhanced styling
              _buildSectionTitle('Recently Uploaded Videos'),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.4, // Responsive height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return _buildRecentlyUploadedVideoCard(context, videos[index]);
                  },
                ),
              ),
              SizedBox(height: 20),

              // Content Insights Section with enhanced styling
              _buildSectionTitle('Content Insights'),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                color: Colors.grey[100],
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.chartLine, color: Colors.green),
                  title: Text('Engagement Overview',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Likes, Comments, Shares, and Views'),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text('View Insights'),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Monetization Section with enhanced styling
              _buildSectionTitle('Monetization'),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                color: Colors.grey[100],
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading:
                  FaIcon(FontAwesomeIcons.dollarSign, color: Colors.blueAccent),
                  title: Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Total earnings from ads and subscriptions'),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text('View Details'),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build section titles with consistent styling
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }

  // Helper method to build video cards for the Watch History section
  Widget _buildVideoCard(BuildContext context, Map<String, dynamic> video) {
    double cardWidth = MediaQuery.of(context).size.width * 0.6;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video thumbnail with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                video['thumbnail'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            video['title'],
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            video['views'],
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Helper method to build statistic cards with icons
  Widget _buildStatisticCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 130,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 10),
            Text(
              value,
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildVideoList(
      BuildContext context, List<Map<String, dynamic>> videoList, String infoKey) {
    return Column(
      children: videoList.map((video) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                video['thumbnail'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(video['title'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(video[infoKey],
                style: TextStyle(color: Colors.grey[600])),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {

              },
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildRecentlyUploadedVideoCard(BuildContext context, Map<String, dynamic> video) {
    double cardWidth = MediaQuery.of(context).size.width * 0.7;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  video['thumbnail'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(video['title'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('Views: ${video['views']}',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
