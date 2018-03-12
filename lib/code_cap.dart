import 'dart:async';

import 'package:cap_challenge/models/add_code_result.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/QRCodeReader.dart';

class CodeCap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CodeCapState();
  }
}

class CodeCapState extends State<CodeCap> {
  TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Center(
          child: new Hero(
            tag: "fab-cap",
            child: new Container(
              height: 300.0,
              width: 300.0,
              child: new Stack(
                children: <Widget>[
                  new Image.asset(
                    "images/cap.png",
                    fit: BoxFit.fill,
                  ),
                  new Center(
                    child: new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 68.0),
                      child: new TextField(
                        maxLength: 14,
                        decoration:
                        new InputDecoration(labelText: "Kod spod nakrętki"),
                        controller: textController,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        new Positioned(
          bottom: 0.0,
          child: new Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 72.0),
              child: new FloatingActionButton(
                onPressed: () {
                  new QRCodeReader().scan().then((String qrCode) {
                    if (qrCode != null) {
                      new Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator
                            .of(context)
                            .pop(new ScannedQRCodeResult(qrCode));
                      });
                    }
                  });
                },
                child: new Image.asset(
                  "images/qr_code.png",
                  width: 32.0,
                  color: Colors.white,
                ),
              )),
        ),
      ],
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => null;
}
