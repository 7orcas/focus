import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus/route.dart';
import 'package:focus/service/language.dart';
import 'package:focus/service/menu.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/database/_mock_data.dart';

enum MainMenuAction { ABOUT, ACCOUNT, SETTINGS, RELOAD, en, mi, de, EXIT }

final List<MenuItem<MainMenuAction>> _menuItems = [
  MenuItem(value: MainMenuAction.ABOUT, label: 'about', icon: Icons.add),
  MenuItem(value: MainMenuAction.ACCOUNT, label: 'account', icon: Icons.label),
  MenuItem(value: MainMenuAction.en, label: 'en', icon: Icons.map),
  MenuItem(value: MainMenuAction.mi, label: 'Mi', icon: Icons.map),
  MenuItem(value: MainMenuAction.de, label: 'de', icon: Icons.map),
  MenuItem(
      value: MainMenuAction.SETTINGS, label: 'settings', icon: Icons.settings),
  MenuItem.divider(),
  MenuItem(
      value: MainMenuAction.RELOAD, label: 'Reload', icon: Icons.data_usage),
  MenuItem(
      value: MainMenuAction.EXIT,
      label: 'logout',
      labelColor: Colors.redAccent,
      icon: Icons.exit_to_app,
      iconColor: Colors.redAccent),
];

final IconData _menuIcon = Icons.reorder;

class MainMenu {
  MainMenu(BuildContext context, Store<AppState> store, Language lang,
      Function onChangeLanguage) {
    _context = context;
    _store = store;
    _onChangeLanguage = onChangeLanguage;
    _language = lang;
  }

  BuildContext _context;
  Store<AppState> _store;
  Function _onChangeLanguage;
  Language _language;

  void _onPopupMenuSelected(MainMenuAction item) {
    if (MainMenuAction.EXIT == item) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (MainMenuAction.RELOAD == item) {
      //ToDo Mock, delete
      DatabaseMockData().reload().then((value) {
        _store.dispatch(AppState.getLoadAppAction());
      });
    } else if (MainMenuAction.ABOUT == item) {
      Navigator.pushNamed(_context, ROUTE_ABOUT_PAGE);
    } else if (MainMenuAction.en == item) {
      _onChangeLanguage(LANG_ENGLISH);
    } else if (MainMenuAction.mi == item) {
      _onChangeLanguage(LANG_MAORI);
    } else if (MainMenuAction.de == item) {
      _onChangeLanguage(LANG_GERMAN);
    } else if (MainMenuAction.SETTINGS == item) {
      _onChangeLanguage(LANG_GERMAN);
    } else {
      // do nothing
    }
  }

  static get menuItems => _menuItems;
  static get menuIcon => _menuIcon;
  get language => _language;

  get menu {
    Menu m = Menu<MainMenuAction>(_language);
    return [
      PopupMenuButton<MainMenuAction>(
          icon: Icon(_menuIcon),
          onSelected: _onPopupMenuSelected,
          itemBuilder: (BuildContext context) => m.toList(_menuItems))
    ];
  }
}
