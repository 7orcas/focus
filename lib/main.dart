import 'package:flutter/material.dart';
import 'package:focus/page/home/mainmenu.dart';
import 'package:focus/service/database.dart';
import 'package:focus/entity/user.dart';

void main() => runApp(FocusApp());

class FocusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(title: 'Focus'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusDB db = FocusDB();
  final MainMenu mm = MainMenu();
  User user ;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: db.loadUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            user = snapshot.data;
            debugPrint('*** User= ' + user.language);
            return Scaffold(
              appBar: AppBar(title: Text(widget.title), actions: mm.menu),
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
