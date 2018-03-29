import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  TimerPageState createState() {
    return new TimerPageState();
  }
}

class TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  double _fillPercentage = 0.2;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new Transform(
          transform: new Matrix4.identity()
            ..translate(0.0, 350 * (1 - _fillPercentage)),
          child: new Transform(
              alignment: Alignment.center,
              transform: new Matrix4.identity()
                ..scale(0.75),
              child: new Image.asset(
                "images/bubbles.jpg",
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              )),
        ),
        new Image.asset("images/challenge_bottle.png", fit: BoxFit.fill,),
        new Positioned(child: new RaisedButton(
          onPressed: () =>
              setState(() {
                _fillPercentage += 0.1;
                if (_fillPercentage > 1) {
                  _fillPercentage = 0.0;
                }
              }),
          child: new Text("KLIK"),
        ),
          bottom: 32.0,
        )
      ],
    );
  }
}
