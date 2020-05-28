import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
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

          Util(StackTrace.current)
              .out('graph=' + (graph != null ? 'OK' : 'Null'));
          Util(StackTrace.current).out('graph is running=' +
              model.store.state.isGraphBlocRunning().toString());

          if (graph == null) {
            return MaterialApp(home: Container());
          }

//          Runner runner = Runner(graph);
//          runner.run();

          return Scaffold(
              appBar: new AppBar(
                title: Text(model.label('NewGraph')),
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
                          Text(graph.timerAsString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Expanded(
                              child:
                                  FocusChart(graph.chartDataForNewBuild()))
                        ],
                      ),
                    );
                  }),
            );
        });
  }
}

class _ControlButtonsWidget extends StatelessWidget {
  final int _id_group;
  final GraphBuild _runner;
  final _ViewModel model;
  _ControlButtonsWidget(this.model, this._id_group, this._runner);

  Icon icon(IconData d) => Icon(d, color: Colors.white, size: 60);
//  RaisedButton button(String t, IconData d, Function f) => RaisedButton.icon(
//        key: PageStorageKey(t),
//        icon: Icon(d),
//        onPressed: f,
//        label: Text(model.label(t), style: TextStyle(fontSize: 20)),
//      );
  void space(List<Widget> actions) {
    if (actions.length > 0) actions.add(SizedBox(width: 30));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_runner.isWaiting || _runner.isPaused) {
      actions.add(IconButton(
        icon: icon(Icons.play_circle_filled),
        onPressed: () {
          _runner.start();
        },
      ));
    }

    if (_runner.isRunning) {
      space(actions);
      actions.add(IconButton(
        icon: icon(Icons.pause_circle_filled),
        onPressed: () {
          _runner.pause();
        },
      ));
    }

    if (!_runner.isStopped) {
      space(actions);
      actions.add(IconButton(
        icon: icon(Icons.stop),
        onPressed: () {
          model.store.state.graph = null;
          _runner.stop();
        },
      ));
    }

    if (_runner.isStopped) {
      space(actions);
      actions.add(IconButton(
        icon: icon(Icons.save),
        onPressed: () {
          model.onAddGraph(_id_group, _runner);
        },
      ));
//      actions.add(FlatButton(
//        key: PageStorageKey('Save'),
//        onPressed: model.onAddGraph(_id_group, _runner.graph),
//        child: Text(model.label('Save'), style: TextStyle(fontSize: 20)),
//      ));
    }



//    if (_runner.isWaiting || _runner.isPaused) {
//      //actions.add(button('Start', Icons.play_circle_filled, _runner.start));
//      actions.add(RaisedButton.icon(
//        key: PageStorageKey('Start'),
//        icon: Icon(Icons.play_circle_filled),
//        onPressed: _runner.start,
//        label: Text(model.label('Start'), style: TextStyle(fontSize: 20)),
//      ));
//    }
//
//    if (_runner.isRunning) {
//      space(actions);
////      actions.add(button('Pause', Icons.pause_circle_filled, _runner.pause));
//      actions.add(RaisedButton.icon(
//        key: PageStorageKey('Pause'),
//        icon: Icon(Icons.pause_circle_filled),
//        onPressed: _runner.pause,
//        label: Text(model.label('Pause'), style: TextStyle(fontSize: 20)),
//      ));
//    }
//
////    if (!_runner.isStopped) {
////      space(actions);
////      actions.add(RaisedButton.icon(
////        key: PageStorageKey('Stop'),
////        icon: Icon(Icons.stop),
////        onPressed: _runner.stop,
////        label: Text(model.label('Stop'), style: TextStyle(fontSize: 20)),
////      ));
////    }
//
//    if (!_runner.isStopped) {
//      space(actions);
//      actions.add(IconButton(
//        icon: Icon(Icons.stop),
//        onPressed: () {
//          model.store.state.graph = null;
//          _runner.stop();
//        },
//      ));
//    }
//
//    if (_runner.isStopped) {
//      space(actions);
//      actions.add(button(
//          'Save', Icons.save, model.onAddGraph(_id_group, _runner.graph)));
////      actions.add(RaisedButton.icon(
////        key: PageStorageKey('Save'),
////        icon: Icon(Icons.save),
////        onPressed: model.onAddGraph(_id_group, _runner.graph),
////        label: Text(model.label('Save'), style: TextStyle(fontSize: 20)),
////      ));
//    }

    return Row(children: actions);
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
