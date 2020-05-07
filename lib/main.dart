import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/app/app_reducers.dart';
import 'package:focus/model/app/app_middleware.dart';
import 'package:focus/route.dart';
import 'package:focus/page/graph/graph_page.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/page/home/home_page.dart';

//import 'package:redux_dev_tools/redux_dev_tools.dart';  //TODO delete dev tool
//import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart'; //TODO delete dev tool

void main() => runApp(FocusApp());

Store<AppState>
    store; //TODO This is a workaround when using the emulator. Not tested in a actual phone.

class FocusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (store == null) {
      store = Store<AppState>(
        appStateReducer,
        initialState: AppState.initialState(),
        middleware: listMiddleware(),
      );
    }

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Focus',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        onGenerateRoute: handleRoute,
        home: StoreBuilder<AppState>(
            onInit: (store) => store.dispatch(AppState.getLoadAppAction()),
            builder: (BuildContext context, Store<AppState> store)
            {
//                HomePage(store)
              GraphBuild.addGraphToStore(store);
              return GraphPage(null);
            }
        ),
      ),
    );
  }
}
