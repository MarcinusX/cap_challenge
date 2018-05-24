import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/widgets/collection/collection_grid_item.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {
  final Map<Bottle, int> bottleCollection;

  CollectionPage(this.bottleCollection);


  @override
  State<StatefulWidget> createState() {
    return new CollectionPageState();
  }
}

class CollectionPageState extends State<CollectionPage> with SingleTickerProviderStateMixin {
  TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TabBar(tabs: [
          new Tab(
            child: new Text("KAPSLE", style: new TextStyle(color: Colors.red),),
          ),
          new Tab(
            child: new Text("BILETY", style: new TextStyle(color: Colors.red),),
          ),
        ],
        controller: _tabController,
        ),
        new Expanded(
          child: new GridView.count(
              padding: new EdgeInsets.all(8.0),
              crossAxisCount: 3,
              children: widget.bottleCollection.keys.map((bottle) {
                return new CollectionGridItem(
                    bottle, widget.bottleCollection[bottle]);
              }).toList()),
        ),
      ],
    );
  }
}
