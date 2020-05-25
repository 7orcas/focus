import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:focus/route.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/app/app_actions.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/app/app_reducers.dart';
import 'package:focus/model/app/app_middleware.dart';
import 'package:focus/model/group/group_data_access.dart';
import 'package:focus/page/group/group_page.dart';
import 'package:focus/page/home/groups_page.dart';
import 'package:focus/page/util/loading_image.dart';

//import 'package:redux_dev_tools/redux_dev_tools.dart';  //TODO delete dev tool
//import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart'; //TODO delete dev tool

void main() {
  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initialState(),
    middleware: listMiddleware(),
  );
  runApp(FocusApp(store));
}

class FocusApp extends StatelessWidget {
  final Store<AppState> store;
  FocusApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
            title: 'Focus',
            theme:
            ThemeData(primarySwatch: Colors.purple, brightness: Brightness.light),
            themeMode: ThemeMode.light,
            darkTheme: ThemeData(brightness: Brightness.dark),
//            theme: ThemeData(
//              primarySwatch: Colors.purple,
//            ),
            onGenerateRoute: handleRoute,
            home: StoreBuilder<AppState>(
//            onInit: (store) => store.dispatch(LoadAppAction()), //ToDo delete
                builder: (BuildContext context, Store<AppState> store) {
              return FutureBuilder<bool>(
                  future: initialiseGroups(store),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting)
                      return LoadingImage();

                    return GroupPage(store.state.findGroupTile(ID_USER_ME));
                    //return GroupsPage();

                  });
            })));
  }
}
