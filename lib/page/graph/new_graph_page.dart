import 'dart:async';
import 'dart:isolate';
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

          Runner runner = Runner();



          return MaterialApp(
            home: Scaffold(
              appBar: new AppBar(
                title: Text("NewGraph"),
              ),
              body: StreamBuilder<GraphBuild>(
                  stream: graph.stream,
//                  initialData: graph.numbers,
                  builder: (context, snapshot) {
//                    GraphBuild graphBuild = snapshot.data;
                    GraphBuild graphBuild = runner.graphXXX;
                    runner.start();

                    if (!snapshot.hasData)
                      return Center(child: Text('Loading')); //ToDo graphic

                    if (snapshot.hasError)
                      return Center(
                          child: Text('Error: ${snapshot.error}')); //ToDo route

                    return Column(
                      children: <Widget>[
                        _ControlButtonsWidget(viewModel, _id_group, graphBuild),
                        Text(graphBuild.timerAsString()),
                        Expanded(child: FocusChart(graphBuild.chartData()))
                      ],
                    );
                  }),
            ),
          );
        });
  }


//  void start() async{
//    await Isolate.spawn<Runner>(entryPoint, runner.ourFirstReceivePortXXX.sendPort);
//    runner.echoPort = await runner.ourFirstReceivePortXXX.first;
//    runner.echoPort.send(['start', runner.ourSecondReceivePort.sendPort]);
//    var msg = await runner.ourSecondReceivePort.first;
//
//  }
//
//  void entryPoint(Runner runner){
//
//  }


}

class Runner {
  var ourFirstReceivePortXXX;
  var ourSecondReceivePort;
  var echoPort;
  GraphBuild graphXXX;

  Runner(){
    ourFirstReceivePortXXX = ReceivePort();
    ourSecondReceivePort = ReceivePort();
    graphXXX = GraphBuild.isolate(ourFirstReceivePortXXX);
  }

  void start() async{
    await Isolate.spawn<Runner>(entryPoint, ourFirstReceivePortXXX.sendPort);
    echoPort = await ourFirstReceivePortXXX.first;
    echoPort.send(['start', ourSecondReceivePort.sendPort]);
    var msg = await ourSecondReceivePort.first;

  }

  void entryPoint(Runner runner){

  }


  void runXXX (SendPort sendPort) async{
    // open our receive port. this is like turning on
    // our cellphone.
    var ourReceivePort = ReceivePort();

    // tell whoever created us what port they can reach us on
    // (like giving them our phone number)
    sendPort.send(ourReceivePort.sendPort);

    // listen for text messages that are sent to us,
    // and respond to them with this algorithm
    await for (var msg in ourReceivePort) {
      var data = msg[0];                // the 1st element we receive should be their message
      print('echo received "$data"');
      SendPort replyToPort = msg[1];    // the 2nd element should be their port

      // add a little delay to simulate some work being done
      Future.delayed(const Duration(milliseconds: 100), () {
        // send a message back to the caller on their port,
        // like calling them back after they left us a message
        // (or if you prefer, they sent us a text message, and
        // now we’re texting them a reply)
        replyToPort.send('echo said: ' + data);
      });

      // you can close the ReceivePort if you want
      //if (data == "bye") ourReceivePort.close();
    }


  }


}



class _ControlButtonsWidget extends StatelessWidget {
  final int _id_group;
  final GraphBuild _graphBuild;
  final _ViewModel _viewModel;
  _ControlButtonsWidget(this._viewModel, this._id_group, this._graphBuild);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_graphBuild.isWaiting || _graphBuild.isPaused) {
      actions.add(IconButton(
        icon: Icon(Icons.play_circle_filled),
        onPressed: () {
          _graphBuild.start();
        },
      ));
    }

    if (_graphBuild.isRunning) {
      actions.add(IconButton(
        icon: Icon(Icons.pause_circle_filled),
        onPressed: () {
          _graphBuild.pause();
        },
      ));
    }

    if (!_graphBuild.isStopped) {
      actions.add(IconButton(
        icon: Icon(Icons.stop),
        onPressed: () {
          _viewModel.store.state.graph = null;
          _graphBuild.stop();
        },
      ));
    }

    if (_graphBuild.isStopped) {
      actions.add(IconButton(
        icon: Icon(Icons.save),
        onPressed: () {
          _viewModel.onAddGraph(_id_group, _graphBuild);
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
