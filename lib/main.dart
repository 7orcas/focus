import 'package:focus/model/app/app_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/app/app_reducers.dart';
import 'package:focus/model/app/app_middleware.dart';
import 'package:focus/route.dart';
import 'package:focus/page/home/home_page.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        onGenerateRoute: handleRoute,
        home: StoreBuilder<AppState>(
            onInit: (store) => store.dispatch(LoadAppAction()),
            builder: (BuildContext context, Store<AppState> store) {
              return HomePage(store);
//              GraphBuild.addGraphToStore(store);
//              return GraphPage(null);
            }),
      ),
    );
  }
}
