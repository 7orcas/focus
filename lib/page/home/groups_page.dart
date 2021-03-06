import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/route.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/page/home/main_menu_widget.dart';
import 'package:focus/page/base_view_model.dart';
import 'package:focus/page/group/group_page.dart';

class GroupsPage extends StatelessWidget {

  final String title = 'Focused Intention';

  @override
  Widget build(BuildContext context) {
    Util(StackTrace.current).out('HomePage graphs build');

    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel model) {

          return Scaffold(
            appBar: AppBar(
              title: Text(model.session.label(title)),
              actions: MainMenu(context, model.store, model.language,
                      model.onChangeLanguage)
                  .menu,
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  AddGroupWidget(model),
                  Expanded(
                    child: GroupListWidget(model),
                  ),
                  Text(model.label('Lang') +
                      ':' +
                      model.session.langCode),
                ],
              ),
            ),
//            drawer: Container(
//              child: ReduxDevTools(store),
//            ),
          );
        });
  }
}

class AddGroupWidget extends StatefulWidget {
  final _ViewModel model;
  AddGroupWidget(this.model);
  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroupWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: widget.model.session.label('AddGroup'),
      ),
      onSubmitted: (String s) {
        controller.clear();
        widget.model.onAddGroup(s);
      },
    );
  }
}

class GroupListWidget extends StatelessWidget {
  final _ViewModel _model;
  GroupListWidget(this._model);

  @override
  Widget build(BuildContext context) {

    var list = List.from(_model.groups);
    list.sort((a, b) {
      if (a.id == ID_USER_ME) return -1;
      if (b.id == ID_USER_ME) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return ListView(
      children: list
          .map((group) => GridTile(
            child: ListTile(
                  title: InkWell(
                    child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Text(group.name),
                            SizedBox(width: 10),
                            Text(group.lastGraphFormat()),
                            SizedBox(width: 10),
                            Text('count=' + group.unreadComments.toString()),
                            SizedBox(width: 10),
                            Expanded(child: Text(group.lastComment ?? 'x')),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, ROUTE_GROUP_PAGE,
                            arguments: group),
                    ),
                  ),
                  leading: group.id == ID_USER_ME?
                  SizedBox(width: 50) :
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _model.onRemoveGroup(group),
                  ),

                ),
          ))
          .toList(),
    );
  }
}

class _ViewModel extends BaseViewModel {
  final Function(String) onAddGroup;
  final Function(GroupTile) onRemoveGroup;

  _ViewModel({
    store,
    this.onAddGroup,
    this.onRemoveGroup,
  }) : super(store);

  factory _ViewModel.create(Store<AppState> store) {
    Util(StackTrace.current).out('create viewmodel');

    ///Here for testing only
    _onAddGroup(String name) {
      store.dispatch(AddGroupAction(GroupTile(
          id: null,
          name: name,
          publicKey: null,
          privateKey: null,
          graphs: List<GraphTile>())));
    }

    _onRemoveGroup(GroupTile group) {
      store.dispatch(DeleteGroupAction(group));
    }


    return _ViewModel(
      store: store,
      onAddGroup: _onAddGroup,
      onRemoveGroup: _onRemoveGroup,
    );
  }
}
