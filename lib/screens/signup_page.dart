// lib/signup_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; // For API call
import 'dart:convert'; // For JSON encoding
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For icons

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  // Controllers for TextFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController(); // New
  final TextEditingController _phoneController = TextEditingController(); // New
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Animation Controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Define a Fade Animation
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _animationController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to handle sign up logic and add user to Firebase
  Future<void> _handleSignUp() async {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim(); // New
    String phoneNumber = _phoneController.text.trim(); // New
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Validation
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        age.isEmpty || // New
        phoneNumber.isEmpty // New
    ) {
      _showError('Please fill all fields.');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Add user to Firebase Authentication
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Call the /api/user endpoint
      await _createUserInBackend(name, email, age, phoneNumber);

      _showSuccess('Sign up successful!');

      // Optionally navigate to home or login page
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      _showError(e.message ?? 'An error occurred with authentication.');
    } on Exception catch (e) {
      print('Exception during sign-up: $e');
      _showError(e.toString());
    } catch (e) {
      print('Unknown error during sign-up: $e');
      _showError('An unknown error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to call the /api/user endpoint
  Future<void> _createUserInBackend(
      String name, String email, String age, String phoneNumber) async {
    final String apiUrl = 'https://api.nexstream.live/api/user';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'age': int.parse(age), // Ensure age is sent as an integer
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Optionally, parse the response body to confirm success
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['success'] == true) {
        // User created successfully
      } else {
        String errorMessage = responseBody['message'] ?? 'Unknown error';
        throw Exception(errorMessage);
      }
    } else {
      // Handle non-success status codes
      String errorMessage =
          'Failed to create user in backend. Status code: ${response.statusCode}';
      // Optionally, parse the response body for more details
      try {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('message')) {
          errorMessage = responseBody['message'];
        }
      } catch (e) {
        // Ignore parsing errors
      }
      throw Exception(errorMessage);
    }
  }

  // Show success message
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Use the app logo as in the homepage
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stream,
                color: Colors.blueAccent,
                size: 60,
              ),
              SizedBox(width: 8),
              Text(
                'Nexstream',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Create an Account',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 60, // Increased height
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[700]),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // Less rounded corners
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          ),
          keyboardType: inputType,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ElevatedButton(
        onPressed: _handleSignUp,
        style: ElevatedButton.styleFrom(
          primary: Colors.black, // Changed to black background
          onPrimary: Colors.white, // White text
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Less rounded corners
          ),
          elevation: 5,
        ),
        child: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(color: Colors.grey[700]),
            children: [
              TextSpan(
                text: 'Log in',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height for responsive design
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Use a solid background color for a professional look
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              _buildLogo(),
              SizedBox(height: 30),
              _buildTextField(
                controller: _nameController,
                hintText: 'Name',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _ageController,
                hintText: 'Age',
                icon: Icons.cake_outlined,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
                inputType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 30),
              _buildSignUpButton(),
              SizedBox(height: 20),
              _buildLoginText(),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
