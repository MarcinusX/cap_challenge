import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

DatabaseReference ref;

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
    return new Center(
      child: new Text(_label),
    );
  }
}
