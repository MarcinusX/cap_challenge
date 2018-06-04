import 'package:cap_challenge/logic/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  final int points;
  final int tickets;
  final int rankingPlace;

  const ProfileDialog({Key key, this.points, this.tickets, this.rankingPlace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Center(child: new Text("Profil użytkownika")),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new CircleAvatar(
              radius: 36.0,
              backgroundImage:
                  new NetworkImage(AuthService.instance.currentUser.photoUrl),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                AuthService.instance.currentUser.displayName,
                style: new TextStyle(fontSize: 22.0),
              ),
            ),
            new Text(
              AuthService.instance.currentUser.email,
              style: new TextStyle(fontSize: 14.0),
            ),
            new Divider(),
            new Text("Liczba punktów: $points"),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("Liczba biletów: $tickets"),
            ),
            new Text("Miejsce w rankingu: $rankingPlace"),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            AuthService.instance.logout().then((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("login");
            });
          },
          child: new Text("WYLOGUJ"),
          textColor: Colors.red,
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: new Text("ZAMKNIJ"),
          textColor: Colors.red,
        )
      ],
    );
  }
}
