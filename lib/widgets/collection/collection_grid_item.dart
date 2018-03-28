import 'package:cap_challenge/models/bottle.dart';
import 'package:flutter/material.dart';

class CollectionGridItem extends StatelessWidget {
  final Bottle bottle;
  final int quantity;

  CollectionGridItem(this.bottle, this.quantity);

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(2.0),
          child: new Card(
            child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Image.asset(
                  bottle.imagePath,
                  fit: BoxFit.cover,
                ),
                new Positioned(
                  bottom: 2.0,
                  left: 2.0,
                  child: new Text(
                    bottleCapacityToShortString(bottle.capacity),
                    style: new TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Positioned(
          top: 0.0,
          right: 0.0,
          child: new CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 12.0,
            child: new Text(
              "$quantity",
              style: new TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
