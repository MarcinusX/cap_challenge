import 'package:cap_challenge/models/challenge.dart';
import 'package:flutter/material.dart';

Widget getRewardView(Challenge challenge) {
  return new Row(
    children: <Widget>[
      new Text(
        challenge.reward.toString(),
        style: new TextStyle(
            color: Colors.yellow[600],
            fontWeight: FontWeight.bold,
            fontSize: 24.0),
      ),
      new Icon(
        Icons.monetization_on,
        color: Colors.yellow[600],
        size: 36.0,
      ),
    ],
  );
}