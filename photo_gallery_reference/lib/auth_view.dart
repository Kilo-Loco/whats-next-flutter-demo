import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

class AuthView extends StatefulWidget {
  // Callback for notifying navigator of sign in
  final VoidCallback didSignIn;

  AuthView({Key key, @required this.didSignIn}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _signInButton()),
    );
  }

  // Button to trigger web sign in
  Widget _signInButton() {
    return ElevatedButton(
      child: Text('Sign In'),
      onPressed: () => _webSignIn(),
    );
  }

  // Trigger web sign in window to open
  void _webSignIn() async {
    try {
      // Wait for sign in result from web UI
      final result = await Amplify.Auth.signInWithWebUI();

      // Trigger sign in callback if user signed in successfully
      if (result.isSignedIn) {
        widget.didSignIn();
      }
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}
