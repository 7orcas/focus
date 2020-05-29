import 'package:package_info/package_info.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("About"),
        ),
        body: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(), // async work
            builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading....');
                default:
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: 100,
                      child: Column(

                        children: <Widget>[
                          VersionWidget(snapshot.data),
                          Text('About....'),
                        ],
                      ),
                    ),
                  );
              }
            }));
  }
}

class VersionWidget extends StatelessWidget {
  VersionWidget(this.info);

  final PackageInfo info;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: <Widget>[
        Text('AppName: ' + info.appName),
        Text('Package Name: ' + info.packageName),
        Text('Version: ' + info.version),
        Text('Build Number: ' + info.buildNumber),
      ]),
    );
  }
}
