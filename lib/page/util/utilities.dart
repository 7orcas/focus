import 'dart:async';
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
    String title, String message, Function label, BuildContext context) async {
  TextStyle button = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple);

  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label(title)),
          titleTextStyle: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.purple),
          content: Text(label(message),
              style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(label('Yes'), style: button),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(label('No'), style: button),
            )
          ],
        );
      });
}

LinearGradient get chakraColors => LinearGradient(
        colors: [
          Colors.purple,
          Colors.indigo,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.red,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(0.0, 1.0),
        tileMode: TileMode.clamp);
