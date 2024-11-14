// lib/profile_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final String apiUrl = 'https://api.nexstream.live/api/user/details';


        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': user.email,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _userData = json.decode(response.body);
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load user data');
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: Text('No user data found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${_userData!['name']}'s Profile"), // Changed to double quotes
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Name'),
              subtitle: Text(_userData!['name'] ?? ''),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(_userData!['email'] ?? ''),
            ),
            // Add more fields if your backend provides them
            if (_userData!['age'] != null)
              ListTile(
                title: Text('Age'),
                subtitle: Text(_userData!['age'] ?? ''),
              ),
            if (_userData!['phoneNumber'] != null)
              ListTile(
                title: Text('Phone Number'),
                subtitle: Text(_userData!['phoneNumber'] ?? ''),
              ),
          ],
        ),
      ),
    );
  }
}
