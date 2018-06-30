import 'package:cap_challenge/generated/i18n.dart';
import 'package:cap_challenge/logic/actions.dart';
import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/logic/auth_service.dart';
import 'package:cap_challenge/logic/middleware.dart';
import 'package:cap_challenge/logic/reducer.dart';
import 'package:cap_challenge/widgets/login/login_page.dart';
import 'package:cap_challenge/widgets/main_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() async {
  Widget _defaultHome = new LoginPage();

  FirebaseUser currentUser = await AuthService.instance.loadCurrentUser();
  if (currentUser != null) {
    _defaultHome = new MainScaffold();
  }

  runApp(new MyApp(_defaultHome));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store = new Store<AppState>(reduce,
      initialState: new AppState(
          points: 0,
          tickets: 0,
          counter: 0,
          collection: {},
          challenges: [],
          usersRanking: []),
      middleware: [middleware].toList());
  final Widget defaultHome;

  MyApp(this.defaultHome);

  @override
  Widget build(BuildContext context) {
    store.dispatch(new InitAction());
    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        supportedLocales: [
          const Locale('en', ''),
          const Locale('pl', ''),
        ],
        localizationsDelegates: [
          new GeneratedLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: defaultHome,
        routes: {
          "login": (context) => new LoginPage(),
          "main": (context) => new MainScaffold(),
        },
      ),
    );
  }
}
