import 'package:cap_challenge/generated/i18n.dart';
import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/widgets/collection/collection_grid_item.dart';
import 'package:cap_challenge/widgets/collection/ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CollectionPage extends StatefulWidget {


  CollectionPage();

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
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(bottleCollection: store.state.collection,
            numberOfTickets: store.state.tickets);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return new Column(
          children: <Widget>[
            new TabBar(
              tabs: [
                new Tab(
                  child: new Text(
                    S
                        .of(context)
                        .caps,
                    style: new TextStyle(color: Colors.red),
                  ),
                ),
                new Tab(
                  child: new Text(
                    S
                        .of(context)
                        .tickets,
                    style: new TextStyle(color: Colors.red),
                  ),
                ),
              ],
              controller: _tabController,
            ),
            new Expanded(
              child: new TabBarView(
                children: [
                  _buildCapsView(vm),
                  _buildTicketsView(vm),
                ],
                controller: _tabController,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCapsView(_ViewModel vm) {
    if (vm.bottleCollection.values
        .where((quantity) => quantity > 0)
        .isEmpty) {
      return new Center(
        child: new Text(
          S
              .of(context)
              .addFirstCode,
          textAlign: TextAlign.center,
        ),
      );
    }
    return new GridView.count(
      padding: new EdgeInsets.all(8.0),
      crossAxisCount: 3,
      children: vm.bottleCollection.keys.map((bottle) {
        return new CollectionGridItem(bottle, vm.bottleCollection[bottle]);
      }).toList(),
    );
  }

  Widget _buildTicketsView(_ViewModel vm) {
    if (vm.numberOfTickets == 0) {
      return new Center(
        child: new Text(
          S
              .of(context)
              .addFirstChallenge,
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
      itemCount: vm.numberOfTickets,
    );
  }
}

class _ViewModel {
  final Map<Bottle, int> bottleCollection;
  final int numberOfTickets;

  _ViewModel({@required this.bottleCollection, @required this.numberOfTickets});
}
