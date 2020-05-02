import 'package:flutter/material.dart';
import 'package:focus/page/home/mainmenu.dart';
import 'package:focus/service/util.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/service/language.dart';
import 'package:focus/route.dart';



class HomePage extends StatelessWidget {
  final Store<AppState> store;
  HomePage(this.store);

  final String title = 'Focused Intention';

  @override
  Widget build(BuildContext context) {
Util(StackTrace.current).out('HomePage graphs build');
for (GroupTile g in store.state.groups){
  if (g.id==1) Util(StackTrace.current).out('HomePage graphs build constains ' + g.containsGraphs().toString());
}

    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          Language lang = Language(viewModel.session.language);
          viewModel.lang = lang;

          return Scaffold(
            appBar: AppBar(
              title: Text(lang.label(title)),
              actions: MainMenu(context,
                  viewModel.onChangeLanguage, viewModel.session.language)
                  .menu,
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  AddGroupWidget(viewModel),
                  Expanded(
                    child: GroupListWidget(viewModel, store),
                  ),
                  Text(viewModel.lang.label('Lang') + ':' + viewModel.session.language),
                  RemoveGroupsButton(viewModel),
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
        hintText: widget.model.lang.label('AddGroup'),
      ),
      onSubmitted: (String s) {
        controller.clear();
        widget.model.onAddGroup(s);
      },
    );
  }
}

class GroupListWidget extends StatelessWidget {
  final Store<AppState> store;
  final _ViewModel model;
  GroupListWidget(this.model, this.store);

  @override
  Widget build(BuildContext context) {

for (GroupTile g in model.groups){
if (g.id==1) Util(StackTrace.current).out('GroupListWidget graphs build constains ' + g.containsGraphs().toString());
}

    return ListView(
      children: model.groups
          .map((group) => ListTile(
        title: Text(group.name),
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => model.onRemoveGroup(group),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, ROUTE_GROUP_PAGE, arguments: group),
        ),
      ))
          .toList(),
    );
  }
}

class RemoveGroupsButton extends StatelessWidget {
  final _ViewModel model;
  RemoveGroupsButton(this.model);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(model.lang.label('DelGroups')),
      onPressed: () => model.onRemoveGroups(),
    );
  }
}

class _ViewModel {
  Language lang;
  final List<GroupTile> groups;
  final Session session;
  final Function(String) onAddGroup;
  final Function(GroupTile) onRemoveGroup;
  final Function() onRemoveGroups;
  final Function(String) onChangeLanguage;

  _ViewModel({
    this.groups,
    this.session,
    this.onAddGroup,
    this.onRemoveGroup,
    this.onRemoveGroups,
    this.onChangeLanguage,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddGroup(String name) {
      Util(StackTrace.current).out('_onAddGroup, name=' + name);
      store.dispatch(AddGroupAction(name));
    }

    _onRemoveGroup(GroupTile group) {
      store.dispatch(RemoveGroupAction(group));
    }

    _onRemoveGroups() {
      store.dispatch(RemoveGroupsAction());
    }

    _onChangeLanguage(String lang) {
      store.dispatch(ChangeLanguageAction(lang));
    }

    return _ViewModel(
      groups: store.state.groups,
      session: store.state.session,
      onAddGroup: _onAddGroup,
      onRemoveGroup: _onRemoveGroup,
      onRemoveGroups: _onRemoveGroups,
      onChangeLanguage: _onChangeLanguage,
    );
  }
}