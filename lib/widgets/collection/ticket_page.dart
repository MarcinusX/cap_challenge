import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Image.asset(
            "images/ticket-vertical.jpg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new QrImage(
                  data: "A czego tutaj szukamy? :)",
                  size: 220.0,
                  backgroundColor: Colors.white.withAlpha(200),
                ),
              ],
            ),
          ),
          new Positioned.fill(
            bottom: null,
            child: new AppBar(
              backgroundColor: Colors.red.withAlpha(50),
              elevation: 8.0,
              title: new Text("Twój bilet"),
            ),
          ),
          new Positioned.fill(
            top: null,
            child: new Container(
                color: Colors.white.withAlpha(200),
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Pokaż ten bilet sprzedawcy\nw celu odbioru puszki Coca-Cola!",
                    textAlign: TextAlign.center,
                  ),
                )),
          )
        ],
        fit: StackFit.passthrough,
      ),
    );
  }
}
