// lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // Animation Controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();


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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter both email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in using Firebase Authentication
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showError('Login failed. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGitHubLogin() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Step 1: Start the GitHub OAuth login process
      final result = await FlutterWebAuth2.authenticate(
        url:
        'https://github.com/login/oauth/authorize?client_id=<YOUR_GITHUB_CLIENT_ID>&scope=read:user,user:email',
        callbackUrlScheme: 'nexstream',
      );

      // Step 2: Extract the code from the result
      final code = Uri.parse(result).queryParameters['code'];

      // Step 3: Exchange the code for Firebase credentials
      if (code != null) {
        final AuthCredential credential = GithubAuthProvider.credential(code);
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showError('GitHub login failed. No authorization code received.');
      }
    } catch (e) {
      _showError('GitHub login failed. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
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
            'Welcome Back!',
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
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          primary: Colors.black, // Black background
          onPrimary: Colors.white, // White text
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Less rounded corners
          ),
          elevation: 5,
        ),
        child: Center(
          child: Text(
            'Login with Email',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color, // Button color passed as parameter
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Less rounded corners
          ),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'OR',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/signup');
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(color: Colors.grey[700]),
            children: [
              TextSpan(
                text: 'Sign up',
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
              SizedBox(height: screenHeight * 0.1),
              _buildLogo(),
              SizedBox(height: 40),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 30),
              _buildLoginButton(),
              SizedBox(height: 20),
              _buildDivider(),
              SizedBox(height: 20),
              _buildSocialLoginButton(
                text: 'Login with GitHub',
                icon: FontAwesomeIcons.github,
                onPressed: _handleGitHubLogin,
                color: Colors.black, // GitHub's brand color
              ),
              SizedBox(height: 30),
              _buildSignupText(),
              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
