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
  final double shakeThreshold = 800.0;
  AnimationController _animationController;
  Animation _bubblesFlowAnimation;
  double _fillPercentage = 0.2;
  double baseHeight = 800.0;
  double prevTotal = 0.0;
  DateTime lastUpdate = new DateTime.now();
  double _prevX = 0.0, _prevY = 0.0, _prevZ = 0.0;

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

    accelerometerEvents.listen((AccelerometerEvent event) {
      DateTime current = new DateTime.now();
      int diff = current.difference(lastUpdate).inMilliseconds;
      if (diff > 100) {
        lastUpdate = current;

        double speed =
            (_prevX + _prevY + _prevZ - event.x - event.y - event.z).abs() /
                diff *
                10000;

        if (speed > shakeThreshold) {
          print("shake detected w/ speed: $speed");
        }
        setState(() {
          _prevX = event.x;
          _prevY = event.y;
          _prevZ = event.z;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      overflow: Overflow.visible,
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildBottleFilling(),
        _buildProgressIndicatorContainer(),
        _buildBottleOutline(),
        _buildReceiveButton(),
        _buildBottomCaption(context),
      ],
    );
  }

  Positioned _buildBottomCaption(BuildContext context) {
    return new Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 8.0,
      child: new Text(
        "Gdy butelka się napełni odbierz nagrodę,\na pierwsze 100 osób otrzyma dodatkowe 300 punktów!",
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
        transform: new Matrix4.identity()..scale(1.0, 1 - _fillPercentage),
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

  Positioned _buildReceiveButton() {
    return new Positioned(
      child: new RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        textColor: Colors.white,
        onPressed: _fillPercentage > 0.99
            ? () {
                setState(() => _fillPercentage = 0.0);
                print("A $_fillPercentage");
              }
            : () {
                setState(() => _fillPercentage += 0.1);
                print("B $_fillPercentage");
              },
        child: new Text("ODBIERZ NAGRODĘ!"),
        color: Colors.red,
      ),
      top: 18.0,
    );
  }
}
