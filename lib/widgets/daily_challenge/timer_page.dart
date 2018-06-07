import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class TimerPage extends StatefulWidget {
  @override
  TimerPageState createState() {
    return new TimerPageState();
  }
}

class TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _bubblesFlowAnimation;
  double baseHeight = 800.0;

  Timer timer;
  StreamSubscription<AccelerometerEvent> subscription;

  //shaker:
  DateTime lastUpdate = new DateTime.now();
  DateTime lastShake = new DateTime.now().subtract(Duration(seconds: 3));
  final double shakeThreshold = 800.0;
  double x, y, z;
  int counter = 0;
  int maxCounter = 10;

  double get fillPercentage => math.max(0.07, counter / maxCounter);

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      duration: new Duration(seconds: 15),
      vsync: this,
    );
    _bubblesFlowAnimation = new Tween(
      begin: -baseHeight * 2,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _bubblesFlowAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();

    subscription = accelerometerEvents.listen(_onAccelerometerEvent);

    timer = new Timer.periodic(
      Duration(seconds: 1),
          (Timer t) => setState(() {}),
    );
    FirebaseDatabase.instance
        .reference()
        .child("counter")
        .onValue
        .listen((Event ev) {
      counter = ev.snapshot.value % maxCounter;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      children.addAll([
        _buildBottleFilling(),
        _buildProgressIndicatorContainer(),
        _buildBottleOutline(),
      ]);
    } else {
      children.add(new Center(
        child: new Text(
          "${counter * 100 ~/ maxCounter}%",
          style: Theme
              .of(context)
              .textTheme
              .display4,
        ),
      ));
    }
    children.addAll([
      _buildTopCaption(),
      _buildBottomCaption(),
    ]);
    return new Stack(
      overflow: Overflow.visible,
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: children,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  _addPoints(int points) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    FirebaseDatabase.instance
        .reference()
        .child("users/${user.uid}/points")
        .runTransaction((MutableData data) async {
      int pts = (data.value ?? 0) + points;
      return data..value = pts;
    });
  }

  _increaseCounter() {
    FirebaseDatabase.instance
        .reference()
        .child('counter')
        .runTransaction((MutableData data) async {
      int counter = (data.value ?? 0) + 1;
      if (counter % maxCounter == 0) {
        _addPoints(100);
      }
      return data..value = counter;
    });
  }

  _onAccelerometerEvent(AccelerometerEvent event) {
    DateTime current = new DateTime.now();
    int diff = current
        .difference(lastUpdate)
        .inMilliseconds;
    if (diff > 100) {
      lastUpdate = current;

      double speed = ((x ?? event.x) +
          (y ?? event.y) +
          (z ?? event.z) -
          event.x -
          event.y -
          event.z)
          .abs() /
          diff *
          10000;

      if (speed > shakeThreshold) {
        _onShakeEvent(speed);
      }
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    }
  }

  _onShakeEvent(double speed) {
    if (_canShake()) {
      print("Shake $speed");
      _increaseCounter();
      lastShake = new DateTime.now();
    }
  }

  Positioned _buildBottomCaption() {
    return new Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 8.0,
      child: new Text(
        "Dodaj ostatni bąbelek by otrzymać dodatkowe 100 punktów!\nButelka zawiera $counter/$maxCounter bąbelków!",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Transform _buildProgressIndicatorContainer() {
    return new Transform(
      transform: new Matrix4.identity()..scale(0.75),
      alignment: Alignment.center,
      child: new Container(
        transform: new Matrix4.identity()
          ..scale(1.0, 1 - fillPercentage),
        color: const Color(0xFFFAFAFA),
      ),
    );
  }

  AnimatedBuilder _buildBottleFilling() {
    return new AnimatedBuilder(
      animation: _bubblesFlowAnimation,
      builder: (context, child) {
        return new Positioned(
          bottom: _bubblesFlowAnimation.value,
          child: new Container(
            width: 130.0,
            height: 3 * baseHeight,
            child: new Image.asset(
              "images/bubbles_long.jpg",
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Image _buildBottleOutline() {
    return new Image.asset(
      "images/challenge_bottle.png",
      fit: BoxFit.fill,
    );
  }

  Positioned _buildTopCaption() {
    String text = _canShake()
        ? "Potrząśnij telefonem by dodać bąbelek!"
        : "Następny bąbelek dostępny za ${5 - _shakeDiff()}s!";
    return new Positioned(
      child: new Text(text),
      top: 18.0,
    );
  }

  int _shakeDiff() {
    return new DateTime.now()
        .difference(lastShake)
        .inSeconds;
  }

  bool _canShake() {
    return _shakeDiff() >= 5;
  }
}
