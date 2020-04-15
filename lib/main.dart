import 'package:flutter/material.dart';
import 'package:focus/page/home/mainmenu.dart';

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

  MainMenu mm = MainMenu();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: mm.menu

      ),
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
  }
}
