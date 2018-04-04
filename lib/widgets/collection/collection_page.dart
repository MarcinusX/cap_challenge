import 'package:cap_challenge/logic/auth_service.dart';
import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/widgets/collection/collection_grid_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return new CollectionPageState();
  }
}

class CollectionPageState extends State<CollectionPage> {
  Map<Bottle, int> bottleCollection = {};

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(AuthService.instance.currentUser.uid)
        .child('bottles');
    ref.onChildAdded.listen((event) {
      setState(() {
        Bottle bottle = new Bottle(event.snapshot.value['type']);
        if (bottleCollection.containsKey(bottle)) {
          bottleCollection.update(bottle, (i) => i + 1);
        } else {
          bottleCollection.putIfAbsent(bottle, () => 1);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
        padding: new EdgeInsets.all(8.0),
        crossAxisCount: 3,
        children: bottleCollection.keys.map((bottle) {
          return new CollectionGridItem(bottle, bottleCollection[bottle]);
        }).toList());
  }
}
