import 'package:flutter/material.dart';
import 'package:focus/page/home/mainmenu.dart';
import 'package:focus/service/util.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/app/app_actions.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/group/group.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/app/app_reducers.dart';
import 'package:focus/model/app/app_middleware.dart';
import 'package:focus/service/language.dart';
//import 'package:redux_dev_tools/redux_dev_tools.dart';  //TODO delete dev tool
//import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart'; //TODO delete dev tool


void main() => runApp(FocusApp());

class FocusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    util.out('FocusApp build');

    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: [appMiddleware],
    );

    util.out('FocusApp store');
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Focus',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: StoreBuilder<AppState>(
            onInit: (store) => store.dispatch(LoadAppAction()),
            builder: (BuildContext context, Store<AppState> store) =>
                HomePage(store)),
      ),
    );
  }
}

final util = Util(StackTrace.current);

class HomePage extends StatelessWidget {
  final Store<AppState> store;
  HomePage(this.store);

  final String title = 'Focus';

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          Language lang = Language(lang: viewModel.session.language);
          return Scaffold(
            appBar: AppBar(
              title: Text(lang.label(title)),
              actions: MainMenu(
                      viewModel.onChangeLanguage, viewModel.session.language)
                  .menu,
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  AddGroupWidget(viewModel),
                  Expanded(
                    child: GroupListWidget(viewModel),
                  ),
                  Text('language: ' + viewModel.session.language),
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
        hintText: 'add group',
      ),
      onSubmitted: (String s) {
        controller.clear();
        widget.model.onAddGroup(s);
      },
    );
  }
}

class GroupListWidget extends StatelessWidget {
  final _ViewModel model;
  GroupListWidget(this.model);

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
      child: Text('Delete all'),
      onPressed: () => model.onRemoveGroups(),
    );
  }
}

class _ViewModel {
  final List<Group> groups;
  final Session session;
  final Function(String) onAddGroup;
  final Function(Group) onRemoveGroup;
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
      store.dispatch(AddGroupAction(name));
    }

    _onRemoveGroup(Group group) {
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
