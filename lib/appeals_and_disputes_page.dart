import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppealsAndDisputesPage extends StatefulWidget {
  @override
  _AppealsAndDisputesPageState createState() => _AppealsAndDisputesPageState();
}

class _AppealsAndDisputesPageState extends State<AppealsAndDisputesPage> {

  final List<Map<String, dynamic>> activeAppeals = [
    {
      'title': 'Video A',
      'thumbnail': 'https://picsum.photos/seed/active1/400/225',
      'status': 'Pending',
      'dateSubmitted': '2024-10-01',
    },
    {
      'title': 'Video B',
      'thumbnail': 'https://picsum.photos/seed/active2/400/225',
      'status': 'Under Review',
      'dateSubmitted': '2024-09-25',
    },
  ];


  final List<Map<String, dynamic>> pastAppeals = [
    {
      'title': 'Video C',
      'thumbnail': 'https://picsum.photos/seed/past1/400/225',
      'status': 'Approved',
      'dateResolved': '2024-08-15',
    },
    {
      'title': 'Video D',
      'thumbnail': 'https://picsum.photos/seed/past2/400/225',
      'status': 'Rejected',
      'dateResolved': '2024-07-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appeals & Disputes', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Manage your content appeals and policy disputes here.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            // Submit New Appeal Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Submit New Appeal'),
                onPressed: () {

                  _showSubmitAppealDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  onPrimary: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Active Appeals List
            _buildSectionTitle('Active Appeals'),
            ...activeAppeals.map((appeal) => _buildAppealCard(context, appeal, true)).toList(),
            SizedBox(height: 20),

            _buildSectionTitle('Past Appeals History'),
            ...pastAppeals.map((appeal) => _buildAppealCard(context, appeal, false)).toList(),
            SizedBox(height: 20),

            _buildSectionTitle('Guidelines and Resources'),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.bookOpen, color: Colors.blue),
              title: Text('Community Guidelines'),
              onTap: () {

              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.infoCircle, color: Colors.green),
              title: Text('Appeal Process Overview'),
              onTap: () {

              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.questionCircle, color: Colors.orange),
              title: Text('Support FAQ'),
              onTap: () {
                // Open Support FAQ
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.headset, color: Colors.redAccent),
              title: Text('Contact Support'),
              onTap: () {
                // Open Contact Support
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style:
          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAppealCard(BuildContext context, Map<String, dynamic> appeal, bool isActive) {
    Color statusColor;
    switch (appeal['status']) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Under Review':
        statusColor = Colors.blue;
        break;
      case 'Approved':
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 1, // Square aspect ratio
            child: Image.network(
              appeal['thumbnail'],
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          appeal['title'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isActive
                  ? 'Date Submitted: ${appeal['dateSubmitted']}'
                  : 'Date Resolved: ${appeal['dateResolved']}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Status: ${appeal['status']}',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: isActive
            ? PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'View Details') {
              _showAppealDetailsDialog(context, appeal);
            } else if (value == 'Withdraw Appeal') {
              _withdrawAppeal(appeal);
            }
          },
          itemBuilder: (BuildContext context) {
            return {'View Details', 'Withdraw Appeal'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          icon: Icon(Icons.more_vert),
        )
            : IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            _showAppealDetailsDialog(context, appeal);
          },
        ),
      ),
    );
  }

  void _showSubmitAppealDialog(BuildContext context) {
    // Implement the submission form dialog
    showDialog(
      context: context,
      builder: (context) {
        String? selectedContent;
        String? reason;
        return AlertDialog(
          title: Text('Submit New Appeal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Select Content
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select Content'),
                  items: ['Video A', 'Video B', 'Video C']
                      .map((content) => DropdownMenuItem(
                    value: content,
                    child: Text(content),
                  ))
                      .toList(),
                  onChanged: (value) {
                    selectedContent = value!;
                  },
                ),
                SizedBox(height: 10),
                // Reason for Appeal
                TextFormField(
                  decoration: InputDecoration(labelText: 'Reason for Appeal'),
                  maxLines: 3,
                  onChanged: (value) {
                    reason = value;
                  },
                ),
                SizedBox(height: 10),
                // Attach Supporting Documents
                TextButton.icon(
                  icon: Icon(Icons.attach_file),
                  label: Text('Attach Supporting Documents'),
                  onPressed: () {
                    // Implement file picker
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate and submit the appeal
                Navigator.pop(context);
                _showSuccessMessage('Appeal submitted successfully!');
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showAppealDetailsDialog(BuildContext context, Map<String, dynamic> appeal) {
    // Implement the appeal details dialog
    showDialog(
      context: context,
      builder: (context) {
        Color statusColor;
        switch (appeal['status']) {
          case 'Pending':
            statusColor = Colors.orange;
            break;
          case 'Under Review':
            statusColor = Colors.blue;
            break;
          case 'Approved':
            statusColor = Colors.green;
            break;
          case 'Rejected':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.grey;
        }

        return AlertDialog(
          title: Text('Appeal Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with responsive height
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      appeal['thumbnail'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  appeal['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Status: ${appeal['status']}',
                    style: TextStyle(color: statusColor)),
                SizedBox(height: 10),
                // Violation Details
                Text('Violation Type: Community Guidelines Violation',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Explanation: Detailed explanation of the violation.'),
                SizedBox(height: 10),
                // Appeal Status Progress Bar
                LinearProgressIndicator(
                  value: 0.5, // Dummy progress value
                ),
                SizedBox(height: 10),
                // Communication Log
                Text('Communication Log',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text('User Message'),
                  subtitle: Text('I believe this was a mistake because...'),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.support_agent)),
                  title: Text('Support Response'),
                  subtitle: Text('We are reviewing your appeal.'),
                ),
                // Add Message Button
                TextButton.icon(
                  icon: Icon(Icons.message),
                  label: Text('Add Message'),
                  onPressed: () {
                    // Implement add message functionality
                  },
                ),
              ],
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
  }

  void _withdrawAppeal(Map<String, dynamic> appeal) {

    setState(() {
      activeAppeals.remove(appeal);
    });
    _showSuccessMessage('Appeal withdrawn successfully!');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
