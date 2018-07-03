import 'package:cap_challenge/generated/i18n.dart';
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
                  data: S
                      .of(context)
                      .ticketPlaceholder,
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
              title: new Text(S
                  .of(context)
                  .yourTicket),
            ),
          ),
          new Positioned.fill(
            top: null,
            child: new Container(
                color: Colors.white.withAlpha(200),
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    S
                        .of(context)
                        .showTicketMsg,
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
