import 'package:flutter/material.dart';
import 'package:focus/page/base_view_model.dart';
import 'package:focus/page/home/mainmenu.dart';
import 'package:focus/service/util.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/route.dart';

class HomePage extends StatelessWidget {
  final Store<AppState> store;
  HomePage(this.store);

  final String title = 'Focused Intention';

  @override
  Widget build(BuildContext context) {
    Util(StackTrace.current).out('HomePage graphs build');

    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.session.label(title)),
              actions: MainMenu(context, store, viewModel.language,
                      viewModel.onChangeLanguage)
                  .menu,
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  AddGroupWidget(viewModel),
                  Expanded(
                    child: GroupListWidget(viewModel, store),
                  ),
                  Text(viewModel.label('Lang') +
                      ':' +
                      viewModel.session.langCode),
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
  final Store<AppState> store;
  final _ViewModel model;
  GroupListWidget(this.model, this.store);

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Navigator.pushNamed(
                      context, ROUTE_GROUP_PAGE,
                      arguments: group),
                ),
              ))
          .toList(),
    );
  }
}

class _ViewModel extends BaseViewModel {
  final Function(String) onAddGroup;
  final Function(GroupTile) onRemoveGroup;
  final Function() onRemoveGroups;
  final Function(String) onChangeLanguage;

  _ViewModel({
    store,
    this.onAddGroup,
    this.onRemoveGroup,
    this.onRemoveGroups,
    this.onChangeLanguage,
  }) : super(store);

  factory _ViewModel.create(Store<AppState> store) {
    Util(StackTrace.current).out('creat viewmodel');

    _onAddGroup(String name) {
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
      store: store,
      onAddGroup: _onAddGroup,
      onRemoveGroup: _onRemoveGroup,
      onRemoveGroups: _onRemoveGroups,
      onChangeLanguage: _onChangeLanguage,
    );
  }
}
