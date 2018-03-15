import 'package:cap_challenge/logic/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            gradient: new RadialGradient(colors: [
              Colors.red,
              Colors.orange,
            ], radius: 1.0),
          ),
        ),
        new Align(
            alignment: Alignment.bottomCenter,
            child: new Image.asset(
              "images/coca_family.png",
              fit: BoxFit.fill,
            )),
        new Center(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 72.0, horizontal: 8.0),
                child: new Text(
                  "Cap Challenge",
                  style: Theme.of(context).textTheme.display2.copyWith(
                        color: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? Colors.white
                            : Colors.black,
                        fontFamily: "Marker",
                      ),
                ),
              ),
              new OAuthLoginButton(
                  onPressed: () => _loginWithGoogle(context),
                  text: "Continue with Google",
                  assetName: "images/sign-in-google.png",
                  backgroundColor: Colors.red),
              new Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: new OAuthLoginButton(
                    onPressed: () => _loginWithFacebook(context),
                    text: "Continue with Facebook",
                    assetName: "images/sign-in-facebook.png",
                    backgroundColor: Colors.blue[700]),
              ),
            ],
          ),
        )
      ],
    );
  }

  _loginWithFacebook(BuildContext context) async {
    FirebaseUser user = await AuthService.instance.logInWithFacebook();
    if (user != null) {
      Navigator.of(context).pushReplacementNamed("main");
    }
  }

  _loginWithGoogle(BuildContext context) async {
    FirebaseUser user = await AuthService.instance.loginWithGoogle();
    if (user != null) {
      Navigator.of(context).pushReplacementNamed("main");
    }
  }
}

class OAuthLoginButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final String assetName;
  final Color backgroundColor;

  OAuthLoginButton(
      {@required this.onPressed,
      @required this.text,
      @required this.assetName,
      @required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 240.0,
      child: new RaisedButton(
        color: backgroundColor,
        onPressed: onPressed,
        padding: new EdgeInsets.only(right: 8.0),
        child: new Row(
          children: <Widget>[
            new Image.asset(
              assetName,
              height: 36.0,
            ),
            new Expanded(
                child: new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                text,
                style: Theme
                    .of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
