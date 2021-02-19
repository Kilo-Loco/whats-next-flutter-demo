import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'auth_view.dart';
import 'gallery_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Track whether current user is signed in
  bool _isSignedIn;

  // Trigger Amplify to configure immediately
  @override
  void initState() {
    super.initState();

    // Once configured, attempt to sign user in
    _configureAmplify().then((_) => _attemptAutoLogin());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _isSignedIn != null ? _appNavigator() : _loadingView());
  }

  // Manage app navigation
  Widget _appNavigator() {
    return Navigator(
      pages: [
        // Show Auth View
        MaterialPage(
            child:
                AuthView(didSignIn: () => setState(() => _isSignedIn = true))),

        // Show Gallery View if user is signed in
        if (_isSignedIn)
          MaterialPage(
              child: GalleryView(
                  didSignOut: () => setState(() => _isSignedIn = false)))
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // Initial loading view
  Widget _loadingView() {
    return Container(
      color: Colors.white,
    );
  }

  // Add plugins and configure Amplify
  Future<void> _configureAmplify() async {
    try {
      // Add Auth and Storage plugins
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyStorageS3());

      // Configure Amplify
      await Amplify.configure(amplifyconfig);
      print('Amplify configured');
    } catch (e) {
      print('something happened');
    }
  }

  // Determine is user is already logged in
  void _attemptAutoLogin() async {
    try {
      // Fetch Auth session
      final result = await Amplify.Auth.fetchAuthSession();

      // Update state based on user being signed in
      setState(() => _isSignedIn = result.isSignedIn);
    } catch (e) {
      print(e);
    }
  }
}
