import 'package:cap_challenge/generated/i18n.dart';
import 'package:cap_challenge/logic/actions.dart';
import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/logic/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(
            onUserLoggedIn: (user) =>
                store.dispatch(new UserProvidedAction(user))
        );
      },
      builder: (BuildContext context, _ViewModel vm) {
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
            buildShade(context),
            new Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 72.0, horizontal: 8.0),
                    child: new Text(
                      "Cap Challenge",
                      style: Theme
                          .of(context)
                          .textTheme
                          .display2
                          .copyWith(
                        color: Colors.white,
                        fontFamily: "Marker",
                        decorationColor: Colors.black,
                        decorationStyle: TextDecorationStyle.dotted,
                      ),
                    ),
                  ),
                  new OAuthLoginButton(
                    onPressed: () => _loginWithGoogle(context, vm),
                    text: S
                        .of(context)
                        .loginWithGoogle,
                    assetName: "images/sign-in-google.png",
                    backgroundColor: Colors.red,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: new OAuthLoginButton(
                      onPressed: () => _loginWithFacebook(context, vm),
                      text: S
                          .of(context)
                          .loginWithFacebook,
                      assetName: "images/sign-in-facebook.png",
                      backgroundColor: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildShade(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return new Container();
    } else {
      return new Positioned.fill(
        child: new DecoratedBox(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.red.withAlpha(120), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      );
    }
  }

  _loginWithFacebook(BuildContext context, _ViewModel vm) async {
    FirebaseUser user = await AuthService.instance.logInWithFacebook();
    if (user != null) {
      vm.onUserLoggedIn(user);
      Navigator.of(context).pushReplacementNamed("main");
    }
  }

  _loginWithGoogle(BuildContext context, _ViewModel vm) async {
    FirebaseUser user = await AuthService.instance.loginWithGoogle();
    if (user != null) {
      vm.onUserLoggedIn(user);
      Navigator.of(context).pushReplacementNamed("main");
    }
  }
}

class _ViewModel {
  final Function(FirebaseUser) onUserLoggedIn;

  _ViewModel({@required this.onUserLoggedIn});
}

class OAuthLoginButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final String assetName;
  final Color backgroundColor;

  OAuthLoginButton({@required this.onPressed,
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
