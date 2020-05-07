import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_common/src/chart/cartesian/axis/numeric_tick_provider.dart';
import 'package:charts_common/src/chart/cartesian/axis/end_points_tick_provider.dart';
import 'package:focus/route.dart';
import 'package:focus/service/util.dart';
import 'package:focus/service/error.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_actions.dart';

class GraphPage extends StatelessWidget {
  final GroupTile _group;
  GraphPage(this._group) {
    Util(StackTrace.current).out('GraphPage constructor graphs group ' +
        (_group == null ? 'null' : 'not null'));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(context, store),
        builder: (BuildContext context, _ViewModel viewModel) {
          GraphBuild graph = viewModel.store.state.graph;

          Util(StackTrace.current)
              .out('graph=' + (graph != null ? 'NULL' : 'OK'));

          return MaterialApp(
            home: Scaffold(
              appBar: new AppBar(
                title: Text("NewGraph"),
              ),
              body: StreamBuilder<GraphBuild>(
                  stream: graph.stream,
//                  initialData: graph.numbers,
                  builder: (context, snapshot) {
                    GraphBuild graphBuild = snapshot.data;

                    if (!snapshot.hasData)
                      return Center(child: Text('Loading')); //ToDo graphic

                    if (snapshot.hasError)
                      return Center(
                          child: Text('Error: ${snapshot.error}')); //ToDo route

                    return Column(
                      children: <Widget>[
                        _ControlButtonsWidget(viewModel, graphBuild),
//                        Text(graphBuild.numbers.toString()),
                        Expanded(
                            child: LineChart(graphBuild.chartData(),
                                primaryMeasureAxis:
                                NumericAxisSpec(renderSpec: SmallTickRendererSpec(),
                                    showAxisLine: true,
                                    tickProviderSpec: TickProviderSpec(),

                                )

                    ,

                                domainAxis: OrdinalAxisSpec(
                                    // Make sure that we draw the domain axis line.
                                    showAxisLine: true,
                                    // But don't draw anything else.
                                    renderSpec: NoneRenderSpec()))),
                      ],
                    );
                  }),
            ),
          );
        });
  }
}

class _ControlButtonsWidget extends StatelessWidget {
  final GraphBuild graphBuild;
  final _ViewModel model;
  _ControlButtonsWidget(this.model, this.graphBuild);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (graphBuild.isWaiting || graphBuild.isPaused) {
      actions.add(IconButton(
        icon: Icon(Icons.play_circle_filled),
        onPressed: () {
          graphBuild.start();
        },
      ));
    }

    if (graphBuild.isRunning) {
      actions.add(IconButton(
        icon: Icon(Icons.pause_circle_filled),
        onPressed: () {
          graphBuild.pause();
        },
      ));
    }

    if (!graphBuild.isStopped) {
      actions.add(IconButton(
        icon: Icon(Icons.stop),
        onPressed: () {
          graphBuild.stop();
        },
      ));
    }

    return Row(children: actions);
  }
}

class TickProviderSpec implements NumericTickProviderSpec {
  final bool zeroBound = true;
  final bool dataIsInWholeNumbers = false;
  final int desiredTickCount = 4;
  final int desiredMinTickCount = 4;
  final int desiredMaxTickCount = 4;

  @override
  NumericTickProvider createTickProvider(ChartContext context) {
    final provider = NumericTickProvider();
//    provider.getTicks(context: null, graphicsFactory: null, scale: null, formatter: null, formatterValueCache: null, tickDrawStrategy: null, orientation: null)
//    provider.createTicks([0,0.25,0.5,0.75,1], context: context,
//        graphicsFactory: provider.getTicks().graphicsFactory,
//        scale: null,
//        formatter: null,
//        formatterValueCache: null,
//        tickDrawStrategy: null
//    );
    if (zeroBound != null) {
      provider.zeroBound = zeroBound;
    }
    if (dataIsInWholeNumbers != null) {
      provider.dataIsInWholeNumbers = dataIsInWholeNumbers;
    }

    if (desiredMinTickCount != null ||
        desiredMaxTickCount != null ||
        desiredTickCount != null) {
      provider.setTickCount(desiredMaxTickCount ?? desiredTickCount ?? 10,
          desiredMinTickCount ?? desiredTickCount ?? 2);
    }
    return provider;
  }

  @override
  bool operator ==(Object other) =>
      other is BasicNumericTickProviderSpec &&
          zeroBound == other.zeroBound &&
          dataIsInWholeNumbers == other.dataIsInWholeNumbers &&
          desiredTickCount == other.desiredTickCount &&
          desiredMinTickCount == other.desiredMinTickCount &&
          desiredMaxTickCount == other.desiredMaxTickCount;

  @override
  int get hashCode {
    int hashcode = zeroBound?.hashCode ?? 0;
    hashcode = (hashcode * 37) + dataIsInWholeNumbers?.hashCode ?? 0;
    hashcode = (hashcode * 37) + desiredTickCount?.hashCode ?? 0;
    hashcode = (hashcode * 37) + desiredMinTickCount?.hashCode ?? 0;
    hashcode = (hashcode * 37) + desiredMaxTickCount?.hashCode ?? 0;
    return hashcode;
  }
}


class _ViewModel {
  final Store<AppState> store;
  final List<GroupTile> groups;
  final Function(GroupTile group, GraphTile graph) onAddGraph;
  final Function(GraphTile graph) onDeleteGraph;

  _ViewModel({
    this.store,
    this.groups,
    this.onAddGraph,
    this.onDeleteGraph,
  });

  factory _ViewModel.create(BuildContext context, Store<AppState> store) {
    Util(StackTrace.current).out('graph view create, store.state.graph=' +
        (store.state.graph != null ? 'NULL' : 'OK'));

    _onError(FocusError e) {
      Navigator.pushNamed(context, ROUTE_ERROR_PAGE, arguments: e);
    }

    _onAddGraph(GroupTile group, GraphTile graph) {
      Util(StackTrace.current).out('_onAddGraph');
      store.dispatch(AddGraphAction(group, graph));
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
