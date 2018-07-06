import 'package:cap_challenge/generated/i18n.dart';
import 'package:cap_challenge/logic/actions.dart';
import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/logic/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
class ProfileDialog extends StatelessWidget {


  const ProfileDialog({Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(
          points: store.state.points,
          tickets: store.state.tickets,
          rankingPlace: store.state.usersRanking.indexWhere((user) =>
          user.email ==
              AuthService.instance.currentUser.email) +
              1,
          onLogout: () => store.dispatch(new UserProvidedAction(null)),
        );
      },
      builder: (BuildContext context, _ViewModel vm) {
        return new AlertDialog(
          title: new Center(child: new Text(S
              .of(context)
              .userProfile)),
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
                new Text(S.of(context).totalPoints(vm.points.toString())),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                      S.of(context).totalTickets(vm.tickets.toString())),
                ),
                new Text(
                    S.of(context).placeInRanking(vm.rankingPlace.toString())),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                AuthService.instance.logout().then((_) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed("login");
                  vm.onLogout();
                });
              },
              child: new Text(S
                  .of(context)
                  .logout
                  .toUpperCase()),
              textColor: Colors.red,
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: new Text(S
                  .of(context)
                  .close
                  .toUpperCase()),
              textColor: Colors.red,
            )
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final int points;
  final int tickets;
  final int rankingPlace;
  final Function onLogout;

  _ViewModel({@required this.points, @required this.tickets, @required this.rankingPlace, @required this.onLogout});
}
