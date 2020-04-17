import 'package:flutter/material.dart';
import 'package:focus/bloc/session_provider.dart';
import 'package:focus/page/home/mainmenu.dart';
import 'package:focus/service/database.dart';
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

final FocusDB db = FocusDB();

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: db.loadUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final User user = snapshot.data;
            final session = SessionProvider.of(context);
            session.changeLang(user.language);

            final MainMenu mm = MainMenu(lang: session.lang);
            debugPrint('*** User= ' + user.language);
            return Scaffold(
              appBar: AppBar(title: Text(title), actions: mm.menu),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'XXXX',
                    ),
                  ],
                ),
              ),
            );
//            return Text('OK');
          } else
            return Text('Loading...');
        });
  }
}
