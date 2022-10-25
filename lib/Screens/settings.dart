import 'package:flutter/material.dart';
import 'package:musik_task/Services/authentication.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<FirebaseAuthMethods>().deleteAccount(context);
          }, //icon: Icon(Icons.delete, )
          child: Text("Hello"),
        ),
      ),
    );
  }
}
