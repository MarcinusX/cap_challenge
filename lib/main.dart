import 'package:cap_challenge/logic/auth_service.dart';
import 'package:cap_challenge/widgets/login/login_page.dart';
import 'package:cap_challenge/widgets/main_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  Widget _defaultHome = new LoginPage();

  FirebaseUser currentUser = await AuthService.instance.loadCurrentUser();
  if (currentUser != null) {
    _defaultHome = new MainScaffold();
  }

  runApp(new MyApp(_defaultHome));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;

  MyApp(this.defaultHome);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.red),
      home: defaultHome,
      routes: {
        "login": (context) => new LoginPage(),
        "main": (context) => new MainScaffold(),
      },
    );
  }
}
