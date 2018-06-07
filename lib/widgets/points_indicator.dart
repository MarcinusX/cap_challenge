import 'dart:async';

import 'package:flutter/material.dart';

class PointsIndicator extends StatefulWidget {
  final int actualPoints;

  const PointsIndicator({Key key, this.actualPoints}) : super(key: key);

  @override
  _PoinstIndicatorState createState() => _PoinstIndicatorState();
}

class _PoinstIndicatorState extends State<PointsIndicator> {
  int displayPoints;
  Timer timer;

  @override
  void initState() {
    super.initState();
    displayPoints = widget.actualPoints;
    int oneTickMillis = 20;
    timer =
        new Timer.periodic(new Duration(milliseconds: oneTickMillis), (timer) {
      int diff = widget.actualPoints - displayPoints;
      if (diff > 0) {
        setState(() {
          if (diff > 100) {
            displayPoints += (0.1 * diff).round();
          } else if (diff > 20) {
            displayPoints += 3;
          } else {
            displayPoints += 1;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        new Text(
          "$displayPoints",
          style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
        ),
        new Text("pkt"),
      ],
    );
  }
}
