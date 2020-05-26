import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:focus/route.dart';
import 'package:focus/service/util.dart';
import 'package:focus/service/error.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/graph/graph_runner.dart';
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
        builder: (BuildContext context, _ViewModel viewModel) {
          GraphBuild graph = viewModel.store.state.graph;

          Util(StackTrace.current)
              .out('graph=' + (graph != null ? 'OK' : 'Null'));
          Util(StackTrace.current).out('graph is running=' +
              viewModel.store.state.isGraphBlocRunning().toString());

          if (graph == null) {
            return MaterialApp(home: Container());
          }

          Runner runner = Runner(graph);
          runner.run();

          return MaterialApp(
            home: Scaffold(
              appBar: new AppBar(
                title: Text("NewGraph"),
              ),
              body: StreamBuilder<Runner>(
                  stream: runner.stream,
//                  initialData: graph.numbers,
                  builder: (context, snapshot) {
//                    GraphBuild graphBuild = snapshot.data;

                    if (!snapshot.hasData)
                      return Center(child: Text('Loading')); //ToDo graphic

                    if (snapshot.hasError)
                      return Center(
                          child: Text('Error: ${snapshot.error}')); //ToDo route

                    GraphBuild graphBuild = runner.graph;

                    return Column(
                      children: <Widget>[
                        _ControlButtonsWidget(viewModel, _id_group, runner),
                        Text(graphBuild.timerAsString()),
                        Expanded(child: FocusChart(graphBuild.chartData()))
                      ],
                    );
                  }),
            ),
          );
        });
  }
}





class _ControlButtonsWidget extends StatelessWidget {
  final int _id_group;
  final Runner _runner;
  final _ViewModel _viewModel;
  _ControlButtonsWidget(this._viewModel, this._id_group, this._runner);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_runner.isWaiting || _runner.isPaused) {
      actions.add(IconButton(
        icon: Icon(Icons.play_circle_filled),
        onPressed: () {
          _runner.start();
        },
      ));
    }

    if (_runner.isRunning) {
      actions.add(IconButton(
        icon: Icon(Icons.pause_circle_filled),
        onPressed: () {
          _runner.pause();
        },
      ));
    }

    if (!_runner.isStopped) {
      actions.add(IconButton(
        icon: Icon(Icons.stop),
        onPressed: () {
          _viewModel.store.state.graph = null;
          _runner.stop();
        },
      ));
    }

    if (_runner.isStopped) {
      actions.add(IconButton(
        icon: Icon(Icons.save),
        onPressed: () {
          _viewModel.onAddGraph(_id_group, _runner.graph);
        },
      ));
    }

    return Row(children: actions);
  }
}

class _ViewModel {
  final Store<AppState> store;
  final List<GroupTile> groups;
  final Function(int, GraphBuild) onAddGraph;
  final Function(GraphTile graph) onDeleteGraph;

  _ViewModel({
    this.store,
    this.groups,
    this.onAddGraph,
    this.onDeleteGraph,
  });

  factory _ViewModel.create(BuildContext context, Store<AppState> store) {
    Util(StackTrace.current).out('graph view create, store.state.graph=' +
        (store.state.graph != null ? 'OK' : 'Null'));

    _onError(FocusError e) {
      Navigator.pushNamed(context, ROUTE_ERROR_PAGE, arguments: e);
    }

    _onAddGraph(int id_group, GraphBuild graph) {
      Util(StackTrace.current).out('_onAddGraph');
      store.dispatch(SaveGraphAction(id_group, graph));
      Navigator.pop(context);
    }

    _onDeleteGraph(GraphTile graph) {
      Util(StackTrace.current).out('_onDeleteGraph');
      store.dispatch(DeleteGraphAction(graph, _onError));
    }

    return _ViewModel(
      store: store,
      groups: store.state.groups,
      onAddGraph: _onAddGraph,
      onDeleteGraph: _onDeleteGraph,
    );
  }
}
