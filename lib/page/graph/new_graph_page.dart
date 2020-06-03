import 'package:flutter/cupertino.dart';
import 'package:focus/model/app/app_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:screen/screen.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/graph/graph_runner.dart';
import 'package:focus/page/base_view_model.dart';
import 'package:focus/page/util/utilities.dart';
import 'package:focus/page/graph/graph_chart.dart';

class NewGraphPage extends StatelessWidget {
  final int _id_group;
  NewGraphPage(this._id_group) {
    Util(StackTrace.current).out('GraphPage constructor graphs _id_group=' +
        (_id_group == null ? 'null' : _id_group.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(context, store),
        builder: (BuildContext context, _ViewModel model) {
          GraphBuild graph = model.store.state.graph;

          if (graph == null) {
            return MaterialApp(home: Container());
          }

//          Runner runner = Runner(graph);
//          runner.run();

          return WillPopScope(
            onWillPop: () {
              _stop(graph, model);
              return new Future(() => true);
            },
            child: Scaffold(
              appBar: new AppBar(
                title: Text(model.label('NewGraph')),
                automaticallyImplyLeading: !model.store.state.isGraphRunning,
              ),
              body: StreamBuilder<GraphBuild>(
//                  stream: runner.stream,
                  stream: graph.stream,
                  builder: (context, snapshot) {
//                    GraphBuild graphBuild = snapshot.data;

                    if (!snapshot.hasData)
                      return Center(child: Text('Loading')); //ToDo graphic

                    if (snapshot.hasError)
                      return Center(
                          child: Text('Error: ${snapshot.error}')); //ToDo route

//                    GraphBuild graphBuild = runner.graph;

                    return Container(
                      decoration: BoxDecoration(gradient: chakraColors),
                      child: Column(
                        children: <Widget>[
                          _ControlButtonsWidget(model, _id_group, graph),
                          Expanded(
                              child: FocusChart(graph.chartDataForNewBuild(),
                                  FocusChart.titles(model.label)))
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }
}

void _stop(GraphBuild _runner, _ViewModel model) {
  _powerManagement(false, model.store, ignoreRefresh: true);
  model.store.state.graph = null;
  _runner.stop();
}

void _powerManagement(bool v, Store store, {bool ignoreRefresh = false}) async {
  Wakelock.toggle(on: v);
  store.state.graphRunning = v;
  if (v) {
    store.state.brightness = await Screen.brightness;
    Screen.setBrightness(0.5);
  } else {
    Screen.setBrightness(store.state.brightness);
  }
  if (!ignoreRefresh) store.dispatch(RefreshAppAction());
}

class _ControlButtonsWidget extends StatelessWidget {
  final int _id_group;
  final GraphBuild _runner;
  final _ViewModel model;
  _ControlButtonsWidget(this.model, this._id_group, this._runner);

  Icon _icon(IconData d) => Icon(
        d,
        color: Colors.white,
      );
  void _space(List<Widget> actions) {
    if (actions.length > 0) actions.add(SizedBox(width: 20));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_runner.isWaiting || _runner.isPaused) {
      actions.add(IconButton(
        iconSize: 50,
        icon: _icon(Icons.play_circle_filled),
        onPressed: () {
          _powerManagement(true, model.store);
          _runner.start();
        },
      ));
    }

    if (_runner.isRunning) {
      _space(actions);
      actions.add(IconButton(
        iconSize: 50,
        icon: _icon(Icons.pause_circle_filled),
        onPressed: () {
          _powerManagement(false, model.store);
          _runner.pause();
        },
      ));
    }

    if (!_runner.isStopped) {
      _space(actions);
      actions.add(IconButton(
        iconSize: 70,
        icon: _icon(
          Icons.stop,
        ),
        onPressed: () {
          _stop(_runner, model);
        },
      ));
    }

    if (_runner.isStopped) {
      _space(actions);
      actions.add(IconButton(
        iconSize: 50,
        icon: _icon(Icons.save),
        onPressed: () {
          model.onAddGraph(_id_group, _runner);
        },
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: actions),
          Container(
            child: Text(_runner.timerAsString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
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
