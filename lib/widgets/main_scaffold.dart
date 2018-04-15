import 'dart:async';

import 'package:cap_challenge/logic/auth_service.dart';
import 'package:cap_challenge/models/add_code_result.dart';
import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenges_page.dart';
import 'package:cap_challenge/widgets/code_cap.dart';
import 'package:cap_challenge/widgets/collection/collection_page.dart';
import 'package:cap_challenge/widgets/community/community_page.dart';
import 'package:cap_challenge/widgets/daily_challenge/timer_page.dart';
import 'package:cap_challenge/widgets/ranking/ranking_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  final Map<Bottle, int> bottleCollection = {};
  final List<Challenge> challenges = [];

  @override
  State<StatefulWidget> createState() {
    return new MainScaffoldState();
  }
}

class MainScaffoldState extends State<MainScaffold>
    with SingleTickerProviderStateMixin {
  bool _showFab = true;
  bool _isCapOpened = false;
  int _page = 0;

  Widget _buildBody() {
    switch (_page) {
      case 0:
        return new TimerPage();
      case 1:
        return new CollectionPage(widget.bottleCollection);
      case 2:
        return new ChallengesPage(
            widget.bottleCollection, widget.challenges, completeChallenge);
      case 3:
        return new RankingPage();
      case 4:
        return new CommunityPage();
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

  completeChallenge(Challenge challenge) {
    //TODO
  }

  @override
  void initState() {
    super.initState();
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(AuthService.instance.currentUser.uid);
    userRef
        .child('bottles')
        .onValue
        .listen((event) {
      setState(() {
        Map<dynamic, dynamic> bottles = event.snapshot.value;
        bottles.forEach((key, val) {
          Bottle bottle = new Bottle(val['type']);
          if (widget.bottleCollection.containsKey(bottle)) {
            widget.bottleCollection.update(bottle, (i) => i + 1);
          } else {
            widget.bottleCollection.putIfAbsent(bottle, () => 1);
          }
        });
      });
    });

    userRef
        .child('currentChallenges')
        .onChildAdded
        .listen((event) async {
      DataSnapshot dataSnapshot = await FirebaseDatabase.instance
          .reference()
          .child('challenges/${event.snapshot.key}')
          .once();
      Challenge challenge =
      new Challenge.fromMap(dataSnapshot.value, dataSnapshot.key);
      challenge.isCompleted = event.snapshot.value;
      setState(() => widget.challenges.add(challenge));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Cap challenge"),
        actions: <Widget>[
          new GestureDetector(
            child: new Padding(
              padding: const EdgeInsets.all(6.0),
              child: new CircleAvatar(
                radius: 22.0,
                backgroundImage:
                new NetworkImage(AuthService.instance.currentUser.photoUrl),
              ),
            ),
            onTap: () {
              AuthService.instance.logout().then(
                      (_) =>
                      Navigator.of(context).pushReplacementNamed("login"));
            },
          )
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.whatshot),
            title: new Text("Zadanie dnia"),
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.view_module),
            title: new Text("Kolekcja"),
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.star),
            title: new Text("Wyzwania"),
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.swap_vert),
            title: new Text("Ranking"),
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.people),
            title: new Text("Społeczność"),
          ),
        ],
        type: BottomNavigationBarType.shifting,
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
      floatingActionButton: new Builder(
        builder: (BuildContext context) => _buildFab(context),
      ),
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
      tooltip: "Dodaj kod spod nakrętki",
      onPressed: () {
        _pushCapView(context).then((dynamic result) {
          _onCapClosed();
          if (result is ScannedQRCodeResult) {
            _handleQrCode(result, context);
          } else if (result is AddedCodeResult) {
            if (result.isOk) {
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content:
                  new Text("Butelka została dodana do Twojej kolekcji")));
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
