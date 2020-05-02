import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state

class AddGraphAction {
  final GroupTile group;
  final GraphTile graph;
  AddGraphAction(this.group, this.graph){
    Util(StackTrace.current).out('AddGraphAction constructor');
  }
}
