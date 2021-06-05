import 'package:flutter/material.dart';
import 'package:appscheme/appscheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  static AppScheme appScheme = AppSchemeImpl.getInstance();

  @override
  void initState() {
    super.initState();
    appScheme.getInitScheme().then((value) {
      if (value != null) {
        setState(() {
          _platformVersion = "Init  ${value.dataString} map:${value.query}";
        });
      }
    });

    appScheme.getLatestScheme().then((value) {
      if (value != null) {
        setState(() {
          _platformVersion = "Latest ${value.dataString}  map:${value.query}";
        });
      }
    });

    appScheme.registerSchemeListener().listen((event) {
      if (event != null) {
        setState(() {
          _platformVersion = "listen ${event.dataString}  map:${event.query}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [],
        ),
        body: Center(
          child: Text('$_platformVersion\n'),
        ),
      ),
    );
  }
}
