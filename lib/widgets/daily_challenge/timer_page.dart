import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  TimerPageState createState() {
    return new TimerPageState();
  }
}

class TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _bubblesFlowAnimation;
  double _fillPercentage = 0.2;
  double baseHeight = 800.0;

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
    )
        .animate(new CurvedAnimation(
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
        new AnimatedBuilder(
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
        ),
        new Image.asset(
          "images/challenge_bottle.png",
          fit: BoxFit.fill,
        ),
        new Positioned(
          child: new RaisedButton(
            onPressed: () {
//                  _fillPercentage += 0.1;
//                  if (_fillPercentage > 1) {
//                    _fillPercentage = 0.0;
//                  }
              _animationController.forward().then((_) =>
                  _animationController.reset());
            },
            child: new Text("KLIK"),
          ),
          bottom: 32.0,
        )
      ],
    );
  }
}
