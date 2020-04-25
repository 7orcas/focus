import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("About"),
        ),
        body: new Center(
          child: Text('About....'),
        ));
  }
}