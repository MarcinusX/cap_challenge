import 'dart:async';
import 'dart:math' as math;

import 'package:cap_challenge/logic/http_service.dart' show sendBottleCode;
import 'package:cap_challenge/models/add_code_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
//import 'package:qrcode_reader/QRCodeReader.dart';

class CodeCap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CodeCapState();
  }
}

class CodeCapState extends State<CodeCap> with TickerProviderStateMixin {
  TextEditingController _textController;
  AnimationController _animationController;
  Animation _animation;
  bool _shouldShowSubmitButton = false;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        duration: const Duration(seconds: 1), vsync: this);
    _animation = new Tween<double>(begin: 0.0, end: 2 * math.pi)
        .animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
      }
    });
    _textController = new TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: new Material(
        color: Colors.transparent,
        child: new Center(
          child: _buildCap(),
        ),
      ),
    );
  }

  Hero _buildCap() {
    return new Hero(
      tag: "fab-cap",
      child: new Container(
        height: 300.0,
        width: 300.0,
        child: new Stack(
          children: <Widget>[
            _buildCapImage(),
            _buildInput(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCapImage() {
    return new AnimatedBuilder(
      animation: _animation,
      builder: (context, child) =>
      new Transform(
        alignment: Alignment.center,
        transform: new Matrix4.identity()
          ..rotateZ(_animation.value),
        child: new Image.asset(
          "images/cap.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    if (!_shouldShowSubmitButton) {
      return new Container();
    }
    return new Align(
      alignment: Alignment.topCenter,
      child: new Padding(
        padding: const EdgeInsets.only(top: 72.0),
        child: new RaisedButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(16.0),
          ),
          onPressed: () =>
              _sendBottleCode(_textController.text).then(_handleSubmitResponse),
          color: Colors.red,
          child: new Text(
            "WYŚLIJ KOD",
            style: new TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<Response> _sendBottleCode(String code) async {
    _animationController.forward();
    Response response = await sendBottleCode(code);
    _animationController.stop();
    return response;
  }

  _handleSubmitResponse(Response response) {
    if (response.statusCode == 200) {
      Navigator.of(context).pop(new AddedCodeResult(isOk: true));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("Ups..."),
            content: new Text("coś poszło nie tak"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text("Zamknij"),
              )
            ],
          );
        },
      );
    }
  }

  Center _buildInput() {
    return new Center(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 68.0),
        child: new TextField(
          autocorrect: false,
          maxLength: 10,
          decoration: new InputDecoration(labelText: "Kod spod nakrętki"),
          controller: _textController,
          onChanged: (text) =>
              setState(() => _shouldShowSubmitButton = text.length == 10),
        ),
      ),
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
