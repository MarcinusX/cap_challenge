import 'dart:async';

import 'package:cap_challenge/code_cap.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  bool showFab = true;
  bool isCapOpened = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Cap challenge"),
      ),
      body: new Center(),
      floatingActionButton: new Hero(
        tag: "fab-cap",
        child: showFab
            ? new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              new HeroDialogRoute(
                builder: (BuildContext context) {
                  return new Center(
                    child: new CodeCap(),
                  );
                },
              ),
            ).then(
                  (_) {
                setState(() => isCapOpened = false);
                new Future.delayed(
                  const Duration(milliseconds: 5),
                      () => setState(() => showFab = true),
                );
              },
            );
            setState(() => isCapOpened = true);
            new Future.delayed(
              const Duration(milliseconds: 300),
                  () =>
                  setState(
                        () {
                      if (isCapOpened) {
                        showFab = false;
                      }
                    },
                  ),
            );
          },
        )
            : new Container(),
      ),
    );
  }
}
