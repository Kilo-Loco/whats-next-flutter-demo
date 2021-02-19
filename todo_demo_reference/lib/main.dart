import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:todo_demo_reference/todos_view.dart';
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Keep track of Amplify configuration status
  bool _isAmplifyConfigured = false;

  // Call configure Amplify immediately
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: _isAmplifyConfigured ? TodosView() : _loadingView()),
    );
  }

  // Configures Amplify with plugins
  void _configureAmplify() async {
    try {
      // Add plugins
      final dataStorePlugin =
          AmplifyDataStore(modelProvider: ModelProvider.instance);
      await Amplify.addPlugin(dataStorePlugin);
      await Amplify.addPlugin(AmplifyAPI());
      await Amplify.addPlugin(AmplifyAuthCognito());

      // Configure amplify
      await Amplify.configure(amplifyconfig);
      print('Amplify configured');

      // Update state
      setState(() => _isAmplifyConfigured = true);
    } catch (e) {
      print('something happened');
    }
  }

  // Loading Screen
  Widget _loadingView() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
