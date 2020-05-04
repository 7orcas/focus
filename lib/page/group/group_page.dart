import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:focus/route.dart';
import 'package:focus/service/util.dart';
import 'package:focus/service/error.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/group_middleware.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/page/group/graph_conversation.dart';


class GroupPage extends StatelessWidget {
  final GroupTile _group;
  GroupPage(this._group) {
    Util(StackTrace.current).out(
        'GroupPage constructor graphs build constains ' +
            _group.containsGraphs().toString());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(context, store),
        builder: (BuildContext context, _ViewModel viewModel) {
          return FutureBuilder<GroupConversation>(
              future: getGroupConversation(viewModel.store, _group.id),
              builder: (BuildContext context,
                  AsyncSnapshot<GroupConversation> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('....Please wait its loading...')); //ToDo graphic
                } else if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}')); //ToDo route
                else {
                  GroupConversation c = snapshot.data;
                  if (!c.loadedFromStore) {
                    viewModel.store.dispatch(AddGraphsAction(c.toGroupTile()));
                  }
                  return MaterialApp(
                    home: Scaffold(
                      appBar: new AppBar(
                        title: new Text("GroupPage"),
                      ),
                      body: ListView.builder(
                        itemBuilder: (BuildContext context, int index) =>
                            GraphItem(c.graphs[index], viewModel.onDeleteGraph),
                        itemCount: c.graphs.length,
                      ),
                      floatingActionButton: new FloatingActionButton(
                        onPressed: () {
                          viewModel.onAddGraph(
                              _group,
                              GraphTile(
                                  null, c.id, 'yyyy', List<CommentTile>()));
                        },
                        child: new Icon(Icons.add),
                      ),
                    ),
                  );
                }
              });
        });
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
