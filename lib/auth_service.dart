// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<User?> get authStateChanges => _auth.authStateChanges();


  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }


  Future<User?> signInWithGitHub() async {
    const String clientId = '<Your GitHub Client ID>';
    const String redirectUrl = 'https://<your-firebase-project-id>.firebaseapp.com/__/auth/handler';

    final result = await FlutterWebAuth.authenticate(
      url: 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUrl&scope=read:user',
      callbackUrlScheme: 'firebase',
    );

    final Uri uri = Uri.parse(result);
    final code = uri.queryParameters['code'];

    if (code != null) {
      final AuthCredential credential = GithubAuthProvider.credential(code);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    }

    return null;
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
