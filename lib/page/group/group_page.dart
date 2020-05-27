import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:focus/route.dart';
import 'package:focus/service/util.dart';
import 'package:focus/service/error.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_data_access.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/page/base_view_model.dart';
import 'package:focus/page/group/graph_tile_widget.dart';
import 'package:focus/page/graph/graph_conversation_DELETE.dart';
import 'package:focus/page/util/dialog_yes_no.dart';
import 'package:focus/page/util/loading_image.dart';

class GroupPage extends StatelessWidget {
  final GroupTile _group;

  GroupPage(this._group) {}

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(context, store),
        builder: (BuildContext context, _ViewModel model) {
          return FutureBuilder<GroupTile>(
              future: loadGroupConversation(model.store, _group.id),
              builder:
                  (BuildContext context, AsyncSnapshot<GroupTile> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return LoadingImage();

                if (snapshot.hasError)
                  return Center(
                      child: Text('Error: ${snapshot.error}')); //ToDo route

                GroupTile c = snapshot.data;
                String title = c.isUserMe
                    ? model.label('Focus')
                    : model.label('Group') + ': ' + c.name;

                return Scaffold(
                    appBar: new AppBar(
                      title: new Text(title),
                    ),
                    body: ListView.builder(
                      itemBuilder: (BuildContext context, int index) => InkWell(
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GraphTileWidget(c.graphs[index],
                                model.onDeleteGraph, model.label),
                          ),
                          onTap: () => Navigator.pushNamed(
                              context, ROUTE_GRAPH_PAGE,
                              arguments: c.graphs[index]),
                        ),
                      ),
                      itemCount: c.graphs.length,
                    ),
                    floatingActionButton: Visibility(
                        visible: model.store.state.isShowAddGraph,
                        child: new FloatingActionButton(
                            onPressed: () {
                              model.onAddGraph(_group);
                            },
                            child: new Icon(Icons.add))));
              });
        });
  }
}

class _ViewModel extends BaseViewModel {
  final Function(GroupTile group) onAddGraph;
  final Function(GraphTile graph) onDeleteGraph;

  _ViewModel({
    store,
    this.onAddGraph,
    this.onDeleteGraph,
  }) : super(store);

  factory _ViewModel.create(BuildContext context, Store<AppState> store) {
    _onError(FocusError e) {
      Navigator.pushNamed(context, ROUTE_ERROR_PAGE, arguments: e);
    }

    _onAddGraph(GroupTile group) {
      Util(StackTrace.current).out('_onAddGraph');
      //ToDo needs more validation to test if graph is running
      GraphBuild.addGraphToStore(store);
      Util(StackTrace.current).out('graph added to store');
      Navigator.pushNamed(context, ROUTE_NEW_GRAPH_PAGE, arguments: group.id);
    }

    _onDeleteGraph(GraphTile graph) {
      showConfirmDialog(
              'DelGraph', 'DelGraphQ', store.state.session.label, context)
          .then((value) {
        if (value != null && value) store.dispatch(DeleteGraphAction(graph, _onError));
      });
    }

    return _ViewModel(
      store: store,
      onAddGraph: _onAddGraph,
      onDeleteGraph: _onDeleteGraph,
    );
  }
}
