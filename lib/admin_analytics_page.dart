import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminAnalyticsPage extends StatelessWidget {

  final int totalVideosUploaded = 500;
  final int totalViews = 100000;
  final int dailyActiveUsers = 5000;
  final int weeklyActiveUsers = 15000;
  final int monthlyActiveUsers = 50000;
  final double averageWatchTime = 15.5; // in minutes
  final List<String> peakViewingTimes = ['8 PM - 10 PM', '12 PM - 2 PM'];
  final Map<String, double> userDemographics = {
    'Male': 60,
    'Female': 35,
    'Other': 5,
  };
  final List<Map<String, dynamic>> topPerformingVideos = [
    {'title': 'Top Video 1', 'views': 10000},
    {'title': 'Top Video 2', 'views': 8000},
    {'title': 'Top Video 3', 'views': 7000},
  ];
  final List<Map<String, dynamic>> popularGenres = [
    {'genre': 'Action', 'views': 30000},
    {'genre': 'Comedy', 'views': 25000},
    {'genre': 'Drama', 'views': 20000},
  ];
  final int totalLikes = 50000;
  final int totalComments = 10000;
  final int totalShares = 8000;
  final int totalSubscriptions = 12000;
  final int freeUsers = 40000;
  final int paidUsers = 10000;
  final double revenue = 50000;
  final int reportedVideos = 200;
  final int activeViolations = 50;
  final int resolvedIssues = 150;
  final int newSignUps = 5000;
  final double churnRate = 5.5;
  final Map<String, int> deviceUsage = {
    'Mobile': 70000,
    'Desktop': 20000,
    'Smart TV': 10000,
  };
  final List<String> searchTrends = ['Funny Videos', 'Music', 'Live Streams'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Analytics'),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSectionTitle('Content Statistics'),
              _buildStatisticCard(
                'Total Videos Uploaded',
                '$totalVideosUploaded',
                Colors.blueAccent,
                Icons.video_library,
              ),
              _buildStatisticCard(
                'Total Views',
                '$totalViews',
                Colors.green,
                Icons.visibility,
              ),
              _buildStatisticCard(
                'Average Watch Time',
                '$averageWatchTime mins',
                Colors.orange,
                Icons.timer,
              ),
              SizedBox(height: 20),
              _buildSectionTitle('User Engagement'),
              _buildStatisticCard(
                'Daily Active Users',
                '$dailyActiveUsers',
                Colors.redAccent,
                Icons.people,
              ),
              _buildStatisticCard(
                'Monthly Active Users',
                '$monthlyActiveUsers',
                Colors.purple,
                Icons.people_outline,
              ),
              _buildPieChart('User Demographics', userDemographics),
              SizedBox(height: 20),
              _buildSectionTitle('Top Performing Videos'),
              _buildTopVideosList(topPerformingVideos),
              SizedBox(height: 20),
              _buildSectionTitle('Popular Genres'),
              _buildBarChart('Popular Genres', popularGenres),
              SizedBox(height: 20),
              _buildSectionTitle('Engagement Metrics'),
              _buildStatisticCard(
                'Total Likes',
                '$totalLikes',
                Colors.blue,
                Icons.thumb_up,
              ),
              _buildStatisticCard(
                'Total Comments',
                '$totalComments',
                Colors.green,
                Icons.comment,
              ),
              _buildStatisticCard(
                'Total Shares',
                '$totalShares',
                Colors.orange,
                Icons.share,
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Subscription Details'),
              _buildStatisticCard(
                'Free Users',
                '$freeUsers',
                Colors.grey,
                Icons.person_outline,
              ),
              _buildStatisticCard(
                'Paid Users',
                '$paidUsers',
                Colors.amber,
                Icons.person,
              ),
              _buildStatisticCard(
                'Total Revenue',
                '\$$revenue',
                Colors.green,
                Icons.attach_money,
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Content Moderation'),
              _buildStatisticCard(
                'Reported Videos',
                '$reportedVideos',
                Colors.red,
                Icons.report,
              ),
              _buildStatisticCard(
                'Active Violations',
                '$activeViolations',
                Colors.deepOrange,
                Icons.warning,
              ),
              _buildStatisticCard(
                'Resolved Issues',
                '$resolvedIssues',
                Colors.green,
                Icons.check_circle,
              ),
              SizedBox(height: 20),
              _buildSectionTitle('User Acquisition'),
              _buildStatisticCard(
                'New Sign-ups',
                '$newSignUps',
                Colors.blueAccent,
                Icons.person_add,
              ),
              _buildStatisticCard(
                'Churn Rate',
                '$churnRate%',
                Colors.redAccent,
                Icons.trending_down,
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Device and Platform Usage'),
              _buildPieChart('Device Usage', deviceUsage),
              SizedBox(height: 20),
              _buildSectionTitle('Search Trends'),
              _buildSearchTrendsList(searchTrends),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style:
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTopVideosList(List<Map<String, dynamic>> videos) {
    return Column(
      children: videos.map((video) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: Icon(Icons.video_label, color: Colors.blueAccent),
            title: Text(video['title']),
            trailing: Text('${video['views']} views'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchTrendsList(List<String> trends) {
    return Column(
      children: trends.map((trend) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: Icon(Icons.search, color: Colors.green),
            title: Text(trend),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPieChart(String title, Map<String, dynamic> dataMap) {
    List<charts.Series<dynamic, String>> series = [
      charts.Series(
        id: title,
        data: dataMap.entries.toList(),
        domainFn: (entry, _) => entry.key,
        measureFn: (entry, _) => entry.value,
        labelAccessorFn: (entry, _) => '${entry.key}: ${entry.value}%',
      )
    ];

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        child: charts.PieChart<String>(
          series,
          animate: true,
          defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [
              charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.inside,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(String title, List<Map<String, dynamic>> dataList) {
    List<charts.Series<Map<String, dynamic>, String>> series = [
      charts.Series(
        id: title,
        data: dataList,
        domainFn: (data, _) => data['genre'],
        measureFn: (data, _) => data['views'],
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        child: charts.BarChart(
          series,
          animate: true,
        ),
      ),
    );
  }
}
