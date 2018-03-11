import 'package:cap_challenge/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new MainScaffold(),
    );
  }
}
