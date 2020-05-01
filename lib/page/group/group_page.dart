import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:flutter/material.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/comment_entity.dart';
import 'package:focus/service/util.dart';

class GroupPage extends StatelessWidget {
  final GroupTile _group;
  GroupPage(this._group);

  @override
  Widget build(BuildContext context) {
    Store<AppState> store;
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          return FutureBuilder<GroupConversation>(
              future: GroupDB().loadGroupConversation(_group.id),
              builder: (BuildContext context,
                  AsyncSnapshot<GroupConversation> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('....Please wait its loading...'));
                } else if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else {
                  GroupConversation c = snapshot.data;
                  return StoreConnector<AppState, _ViewModel>(
                      converter: (Store<AppState> store) =>
                          _ViewModel.create(store),
                      builder: (BuildContext context, _ViewModel viewModel) {
                        return MaterialApp(
                          home: Scaffold(
                            appBar: new AppBar(
                              title: new Text("GroupPage"),
                            ),
                            body: ListView.builder(
                              itemBuilder: (BuildContext context, int index) =>
                                  GraphItem(c.graphs[index]),
                              itemCount: c.graphs.length,
                            ),
                            floatingActionButton: new FloatingActionButton(
                              onPressed: () {
                                viewModel.onAddGraph(
                                    _group,
                                    GraphEntity.db(101, c.id, 'yyyyy',
                                        List<CommentEntity>()));
                              },
                              child: new Icon(Icons.add),
                            ),
                          ),
                        );
                      });
                }
              });
        });
  }
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class GraphItem extends StatelessWidget {
  const GraphItem(this.entry);

  final GraphEntity entry;

  Widget _buildTiles(GraphEntity root) {
    List<StatelessWidget> comments = [GraphX('model of graph')];
    comments.addAll(entry.comments.map((c) => ItemX(c)).toList());

    return ExpansionTile(
      key: PageStorageKey<GraphEntity>(root),
      title: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(root.graph + '  x'),
      ),
      children: comments,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

abstract class Base extends StatelessWidget {}

class GraphX extends Base {
  final String graph;
  GraphX(this.graph);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        graph,
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ItemX extends Base {
  final CommentEntity comment;
  ItemX(this.comment);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(comment.comment),
        ),
      ],
    );
  }
}

class _ViewModel {
  final List<GroupTile> groups;
  final Function(GroupTile group, GraphEntity graph) onAddGraph;

  _ViewModel({
    this.groups,
    this.onAddGraph,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddGraph(GroupTile group, GraphEntity graph) {
      Util(StackTrace.current).out('_onAddGraph');
      store.dispatch(AddGraphAction(group, graph));
    }

    return _ViewModel(
      groups: store.state.groups,
      onAddGraph: _onAddGraph,
    );
  }
}
