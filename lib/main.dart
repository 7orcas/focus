import 'package:flutter/material.dart';
import 'package:focus/bloc/session_bloc.dart';
import 'package:focus/bloc/session_provider.dart';
import 'package:focus/page/home/mainmenu.dart';
import 'package:focus/service/database.dart';
import 'package:focus/service/util.dart';
import 'package:focus/entity/user.dart';

void main() => runApp(FocusApp());

class FocusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SessionProvider(
      child: MaterialApp(
        title: 'Focus',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: HomePage(title: 'Focus'),
      ),
    );
  }
}

final util = Util(StackTrace.current);

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  MainMenu _initialise(BuildContext context, SessionBloc bloc, String lang){
    MainMenu menu= MainMenu(lang, context);
    util.out('menu l=' + menu.language);
    return menu;
  }


  @override
  Widget build(BuildContext context) {
    final session = SessionProvider.of(context);
    final FocusDB db = FocusDB(context);

    return FutureBuilder<User>(
        future: db.loadUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            final User user = snapshot.data;
//            MainMenu menu = _initialise(session, user);

            return StreamBuilder<String>(
              stream: session.language,
              initialData: 'zz',
              builder: (context, snapshot) {
                MainMenu menu = _initialise(context, session, snapshot.data);
                return Scaffold(
                  appBar: AppBar(title: Text(title),
                  actions: menu != null? menu.menu : null
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'XXXX ' + snapshot.data,
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
            return Text('OK');
          } else
            return Text('Loading...');
        });
  }
}
