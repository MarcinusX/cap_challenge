import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/widgets/collection/collection_grid_item.dart';
import 'package:cap_challenge/widgets/collection/ticket_page.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {
  final Map<Bottle, int> bottleCollection;
  final int numberOfTickets;

  CollectionPage({this.bottleCollection, this.numberOfTickets});

  @override
  State<StatefulWidget> createState() {
    return new CollectionPageState();
  }
}

class CollectionPageState extends State<CollectionPage>
    with SingleTickerProviderStateMixin {
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
        new TabBar(
          tabs: [
            new Tab(
              child: new Text(
                "KAPSLE",
                style: new TextStyle(color: Colors.red),
              ),
            ),
            new Tab(
              child: new Text(
                "BILETY",
                style: new TextStyle(color: Colors.red),
              ),
            ),
          ],
          controller: _tabController,
        ),
        new Expanded(
          child: new TabBarView(
            children: [
              _buildCapsView(),
              _buildTicketsView(),
            ],
            controller: _tabController,
          ),
        ),
      ],
    );
  }

  Widget _buildCapsView() {
    if (widget.bottleCollection.values
        .where((quantity) => quantity > 0)
        .isEmpty) {
      return new Center(
        child: new Text(
          "Naciśnij przycisk \"+\",\naby dodać kod spod nakrętki!",
          textAlign: TextAlign.center,
        ),
      );
    }
    return new GridView.count(
      padding: new EdgeInsets.all(8.0),
      crossAxisCount: 3,
      children: widget.bottleCollection.keys.map((bottle) {
        return new CollectionGridItem(bottle, widget.bottleCollection[bottle]);
      }).toList(),
    );
  }

  Widget _buildTicketsView() {
    if (widget.numberOfTickets == 0) {
      return new Center(
        child: new Text(
          "Wykonaj swoje pierwsze wyzwanie,\naby dostać bilet na darmową Colę!",
          textAlign: TextAlign.center,
        ),
      );
    }
    return new ListView.builder(
      itemBuilder: (context, index) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new GestureDetector(
            onTap: () =>
                Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (context) => new TicketPage())),
            child: new Image.asset(
              "images/ticket.jpg",
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
      itemCount: widget.numberOfTickets,
    );
  }
}
