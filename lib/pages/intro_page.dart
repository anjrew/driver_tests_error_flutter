import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _setupSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (value) => _prefs.setString('title', value),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Url'),
            onChanged: (value) => _prefs.setString('url', value),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Login'),
            onChanged: (value) => _prefs.setString('login', value),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (value) => _prefs.setString('password', value),
          ),
          MaterialButton(
            onPressed: _handleSubmit,
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_hasUrl()) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            const EdgeInsetsGeometry padding = EdgeInsets.all(10);
            return AlertDialog(
              title: const Text('Warning'),
              titlePadding: padding,
              content: const Text('Enter your dismay dashboard url'),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            );
          });
    }
  }

  void _setupSharedPrefs() {
    SharedPreferences.getInstance().then((instance) {
      _prefs = instance;
    });
  }

  bool _hasUrl() {
    final String url = _prefs.getString('url');
    if (url == null || url == '') {
      return false;
    } else {
      return true;
    }
  }
}
