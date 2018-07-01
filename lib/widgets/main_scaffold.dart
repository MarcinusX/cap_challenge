import 'dart:async';

import 'package:cap_challenge/generated/i18n.dart';
import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/logic/auth_service.dart';
import 'package:cap_challenge/models/add_code_result.dart';
import 'package:cap_challenge/widgets/challenges/challenges_page.dart';
import 'package:cap_challenge/widgets/code_cap.dart';
import 'package:cap_challenge/widgets/collection/collection_page.dart';
import 'package:cap_challenge/widgets/daily_challenge/timer_page.dart';
import 'package:cap_challenge/widgets/points_indicator.dart';
import 'package:cap_challenge/widgets/profile_dialog.dart';
import 'package:cap_challenge/widgets/ranking/ranking_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MainScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainScaffoldState();
  }
}

class MainScaffoldState extends State<MainScaffold>
    with SingleTickerProviderStateMixin {
  DatabaseReference userRef = FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(AuthService.instance.currentUser.uid);
  bool _showFab = true;
  bool _isCapOpened = false;
  int _page = 0;

  Widget _buildBody() {
    switch (_page) {
      case 0:
        return new TimerPage();
      case 1:
        return new CollectionPage();
      case 2:
        return new ChallengesPage();
      case 3:
        return new RankingPage();
      default:
        return new TimerPage();
    }
  }

  Widget _buildFab(BuildContext context) {
    switch (_page) {
      case 1:
        return _createHeroFab(context);
      default:
        return new Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(points: store.state.points);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return new Scaffold(
          appBar: new AppBar(
            elevation: 0.0,
            title: new Text("Cap challenge"),
            actions: <Widget>[
              new Center(
                child: new PointsIndicator(
                  actualPoints: vm.points,
                ),
              ),
              new GestureDetector(
                child: new Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new CircleAvatar(
                    radius: 22.0,
                    backgroundImage: new NetworkImage(
                        AuthService.instance.currentUser.photoUrl),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => new ProfileDialog(),
                  );
                },
              ),
            ],
          ),
          body: new Material(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius:
              new BorderRadius.vertical(top: Radius.circular(24.0)),
            ),
            child: _buildBody(),
          ),
          backgroundColor: Colors.red,
          bottomNavigationBar: new BottomNavigationBar(
            items: [
              new BottomNavigationBarItem(
                backgroundColor: Colors.red,
                icon: new Icon(Icons.whatshot),
                title: new Text(S
                    .of(context)
                    .dailyChallenge),
              ),
              new BottomNavigationBarItem(
                backgroundColor: Colors.red,
                icon: new Icon(Icons.view_module),
                title: new Text(S
                    .of(context)
                    .collection),
              ),
              new BottomNavigationBarItem(
                backgroundColor: Colors.red,
                icon: new Icon(Icons.star),
                title: new Text(S
                    .of(context)
                    .challenges),
              ),
              new BottomNavigationBarItem(
                backgroundColor: Colors.red,
                icon: new Icon(Icons.swap_vert),
                title: new Text(S
                    .of(context)
                    .ranking),
              ),
            ],
            type: BottomNavigationBarType.fixed,
            onTap: _navigationTapped,
            currentIndex: _page,
          ),
          floatingActionButton: new Builder(
            builder: (BuildContext context) => _buildFab(context),
          ),
        );
      },
    );
  }

  void _navigationTapped(int page) {
    setState(() => this._page = page);
  }

  Widget _createHeroFab(BuildContext context) {
    return new Hero(
      tag: "fab-cap",
      child: _showFab ? _createActualFab(context) : new Container(),
    );
  }

  Widget _createActualFab(BuildContext context) {
    return new FloatingActionButton(
      child: new Icon(Icons.add),
      tooltip: S
          .of(context)
          .addCodeTooltip,
      onPressed: () {
        _pushCapView(context).then((dynamic result) {
          _onCapClosed();
          if (result is ScannedQRCodeResult) {
            _handleQrCode(result, context);
          } else if (result is AddedCodeResult) {
            if (result.isOk) {
              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text(S
                      .of(context)
                      .codeAddedMsg)));
            }
          }
        });
        _onCapOpened();
      },
    );
  }

  Future _pushCapView(BuildContext context) {
    return Navigator.of(context).push(
      new HeroDialogRoute(
        builder: (BuildContext context) {
          return new Center(
            child: new CodeCap(),
          );
        },
      ),
    );
  }

  void _handleQrCode(ScannedQRCodeResult result, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(result.qrCode),
        ));
  }

  _onCapClosed() {
    setState(() => _isCapOpened = false);
    new Future.delayed(
      const Duration(milliseconds: 5),
      () => setState(() => _showFab = true),
    );
  }

  _onCapOpened() {
    setState(() => _isCapOpened = true);
    new Future.delayed(
      const Duration(milliseconds: 300),
      () => setState(
            () {
              if (_isCapOpened) {
                _showFab = false;
              }
            },
          ),
    );
  }
}

class _ViewModel {
  final int points;

  _ViewModel({@required this.points});
}
