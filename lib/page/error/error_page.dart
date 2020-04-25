import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Error"),
        ),
        body: new Center(
          child: Text('opps'),
        ));
  }
}