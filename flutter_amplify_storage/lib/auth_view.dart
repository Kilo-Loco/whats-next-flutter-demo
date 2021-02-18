import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

class AuthView extends StatefulWidget {
  final VoidCallback didSignIn;

  AuthView({Key key, @required this.didSignIn}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Sign In'),
          onPressed: () => _webSignIn(),
        ),
      ),
    );
  }

  void _webSignIn() async {
    try {
      final res = await Amplify.Auth.signInWithWebUI();
      print(res);
      if (res.isSignedIn) {
        widget.didSignIn();
      }
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}
