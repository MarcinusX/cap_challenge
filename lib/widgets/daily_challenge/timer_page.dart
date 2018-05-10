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
        style: Theme
            .of(context)
            .textTheme
            .caption,
      ),
    );
  }

  Transform _buildProgressIndicatorContainer() {
    return new Transform(
      transform: new Matrix4.identity()
        ..scale(0.75),
      alignment: Alignment.center,
      child: new Container(
        transform: new Matrix4.identity()
          ..scale(1.0, 1 - _fillPercentage),
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
