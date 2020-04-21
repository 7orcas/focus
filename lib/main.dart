import 'package:flutter/material.dart';
//import 'package:focus/bloc/session_bloc.dart';
//import 'package:focus/bloc/session_provider.dart';
import 'package:focus/page/home/mainmenu.dart';
import 'package:focus/service/database.dart';
import 'package:focus/service/util.dart';
//import 'package:focus/entity/user.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app_state.dart';
import 'package:focus/model/session.dart';
import 'package:focus/model/group.dart';
import 'package:focus/redux/session_actions.dart';
import 'package:focus/redux/group_actions.dart';
import 'package:focus/redux/appstate_reducers.dart';
import 'package:focus/redux/session_reducers.dart';
import 'package:focus/redux/group_reducers.dart';
import 'package:focus/redux/middleware.dart';
import 'package:focus/service/language.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';  //delete
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart'; //delete


void main() => runApp(FocusApp());

class FocusApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    util.out('FocusApp build');

    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: [sessionStateMiddleware],
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Focus',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: StoreBuilder<AppState>(
            onInit: (store) => store.dispatch(GetLanguageAction()),
            builder: (BuildContext context, Store<AppState> store) =>
                HomePage(store)),
      ),
    );
  }
}

final util = Util(StackTrace.current);

class HomePage extends StatelessWidget {
  final DevToolsStore<AppState> store;
  HomePage(this.store);

  final String title = 'Focus';

//  MainMenu _initialise(BuildContext context, SessionBloc bloc, String lang){
//    MainMenu menu= MainMenu(context, lang);
//    util.out('menu l=' + menu.language);
//    return menu;
//  }

  @override
  Widget build(BuildContext context) {
//    final session = SessionProvider.of(context);
//    final FocusDB db = FocusDB(context);

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
            drawer: Container(
              child: ReduxDevTools(store),
            ),
          );
        });

//    return Scaffold(
//      appBar: AppBar(title: Text(title),
////      actions: menu != null? menu.menu : null
//      ),
//      body: StoreConnector<AppState, _ViewModel>(
//        converter: (Store<AppState> store) => _ViewModel.create(store),
//        builder: (BuildContext context, _ViewModel viewModel) => Column(
//          children: <Widget>[
//            AddGroupWidget(viewModel),
//            Expanded(child: GroupListWidget(viewModel),),
//            RemoveGroupsButton(viewModel),
//          ],
//        )
//      ),
//
//    );
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
