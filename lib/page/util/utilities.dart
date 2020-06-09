import 'dart:async';
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
    String title, String message, Function label, BuildContext context) async {
  TextStyle button = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple);

  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label(title)),
          titleTextStyle: const TextStyle(
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

Future<bool> showOkDialog(
    String title, String message, Function label, BuildContext context) async {
  TextStyle button = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple);

  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label(title)),
          titleTextStyle: const TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.purple),
          content: Text(label(message),
              style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(label('Ok'), style: button),
            ),

          ],
        );
      });
}


LinearGradient get chakraColors => const LinearGradient(
        colors: const [
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

LinearGradient get graphColors => const LinearGradient(
    colors: const [Color(0xFF9C27B0), Color(0xFFBA68C8), Colors.purple],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    tileMode: TileMode.clamp);

LinearGradient get graphHighlightColors => const LinearGradient(
    colors: const [Colors.white, Color(0xFFBA68C8)],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    tileMode: TileMode.clamp);
