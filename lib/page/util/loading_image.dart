import 'package:flutter/material.dart';

class LoadingImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image:
              'http://archivision.com/educational/samples/files/1A2-F-P-I-2-C1_L.jpg',
            )));
  }
}
