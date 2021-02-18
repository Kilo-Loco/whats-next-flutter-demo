import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_storage/amplifyconfiguration.dart';
import 'package:flutter_amplify_storage/auth_view.dart';
import 'package:flutter_amplify_storage/gallery_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;
  bool _isSignedIn;

  @override
  void initState() {
    super.initState();

    _configureAmplify().then((_) => _attemptAutoLogin());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _isSignedIn != null
            ? Navigator(
                pages: [
                  // Show Auth View
                  MaterialPage(child: AuthView(didSignIn: () {
                    setState(() => _isSignedIn = true);
                  })),

                  // Show Gallery View
                  if (_isSignedIn)
                    MaterialPage(child: GalleryView(didSignOut: () {
                      setState(() {
                        _isSignedIn = false;
                      });
                    }))
                ],
                onPopPage: (route, result) => route.didPop(result),
              )
            : Container(
                color: Colors.white,
              ));
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.configure(amplifyconfig);

      print('amplify configured');

      setState(() => _amplifyConfigured = true);
    } catch (e) {
      print(e);
    }
  }

  void _attemptAutoLogin() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      setState(() => _isSignedIn = result.isSignedIn);
    } catch (e) {
      print(e);
    }
  }
}
