import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_datastore/amplifyconfiguration.dart';
import 'package:flutter_amplify_datastore/models/ModelProvider.dart';
import 'package:flutter_amplify_datastore/todos_view.dart';
import 'package:amplify_api/amplify_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      final dataStorePlugin =
          AmplifyDataStore(modelProvider: ModelProvider.instance);
      await Amplify.addPlugin(dataStorePlugin);
      await Amplify.addPlugin(AmplifyAPI());

      await Amplify.configure(amplifyconfig);
      print('Amplify configured');
    } on AmplifyAlreadyConfiguredException {
      print('Amplify not configured for restart');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MaterialApp(home: TodosView()),
    );
  }
}
