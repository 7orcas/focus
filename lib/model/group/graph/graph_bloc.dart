import 'dart:async';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/service/error.dart';

class GraphBloc {

  GraphBuild _graph;

  GraphBloc(this._graph){
//    _buildActionStreamController.stream.listen(_graph.numbers);
  }

  GraphBuild initialise() {
//    _graph.start(buildAction);
    return _graph;
  }

  //Streams for State Updates
  Stream<GraphBuild> get graphBuildStream => _graphBuildSubject.stream;
  final _graphBuildSubject = BehaviorSubject<GraphBuild>();


//  void dispose(){
//    _buildActionStreamController.close();
//  }

  bool isGraphBlocRunning () {
    return this._graph != null && this._graph.isRunning();
  }





}

//class GraphBlocProvider extends InheritedWidget {
//  final GraphBloc bloc;
//
//  GraphBlocProvider({
//    Key key,
//    @required this.bloc,
//    Widget child,
//  }) : super(key: key, child: child);
//
//  @override
//  bool updateShouldNotify(InheritedWidget oldWidget) => true;
//
//  //ToDo update
//  static GraphBloc of(BuildContext context) =>
//      (context.inheritFromWidgetOfExactType(GraphBlocProvider) as GraphBlocProvider).bloc;
//}