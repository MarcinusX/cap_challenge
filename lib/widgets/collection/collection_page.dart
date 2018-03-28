import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/widgets/collection/collection_grid_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

DatabaseReference ref;

Map<Bottle, int> bottleCollection = {
  Bottle.SPRITE_300: 1,
  Bottle.SPRITE_500: 2,
  Bottle.ZERO_1L: 1,
  Bottle.SPRITE_2L: 2,
  Bottle.COCA_COLA_1L: 3,
  Bottle.ZERO_300: 1,
  Bottle.SPRITE_1L: 2,
  Bottle.LIGHT_300: 3,
};
class CollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CollectionPageState();
  }
}

class CollectionPageState extends State<CollectionPage> {

  String _label = "Collection";


  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.reference().child("label");
    ref.onValue.listen((e) {
      setState(() => _label = e.snapshot.value);
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
