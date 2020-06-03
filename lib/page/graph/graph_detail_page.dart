import 'package:flutter/cupertino.dart';
import 'package:focus/model/app/app_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:screen/screen.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/graph/graph_runner.dart';
import 'package:focus/page/base_view_model.dart';
import 'package:focus/page/util/utilities.dart';
import 'package:focus/page/graph/graph_chart.dart';

class GraphDetailPage extends StatelessWidget {
  GraphDetailPage(this._graph);

  final GraphTile _graph;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(context, store),
        builder: (BuildContext context, _ViewModel model) {
          if (_graph == null) {
            return MaterialApp(home: Container());
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(_graph.createdFormat()),
              ),
              body: Container(
                decoration: BoxDecoration(gradient: chakraColors),
                child: Column(children: <Widget>[
                  Expanded(
                      child: FocusChart(
                          GraphBuild.getChartData(
                              GraphBuild.fromList(_graph.graph)),
                          FocusChart.titles(model.label)))
                ]),
              ));
        });
  }
}

class _ViewModel extends BaseViewModel {
  final Function(int, GraphBuild) onAddGraph;

  _ViewModel({
    store,
    this.onAddGraph,
  }) : super(store);

  factory _ViewModel.create(BuildContext context, Store<AppState> store) {
    _onAddGraph(int id_group, GraphBuild graph) {
      Util(StackTrace.current).out('_onAddGraph');
      store.dispatch(SaveGraphAction(id_group, graph));
      Navigator.pop(context);
    }

    return _ViewModel(
      store: store,
      onAddGraph: _onAddGraph,
    );
  }
}
