import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus/service/menu.dart';
import 'package:focus/bloc/session_bloc.dart';
import 'package:focus/bloc/session_provider.dart';

enum MainMenuAction { ABOUT, ACCOUNT, SETTINGS, EXIT }

final List<MenuItem<MainMenuAction>> _menuItems = [
  MenuItem(value: MainMenuAction.ABOUT, label: 'item1', icon: Icons.add),
  MenuItem(value: MainMenuAction.ACCOUNT, label: 'Maori', icon: Icons.label),
  MenuItem(
      value: MainMenuAction.SETTINGS,
      label: 'item3 alksf lkjd ',
      icon: Icons.settings),
  MenuItem.divider(),
  MenuItem(
      value: MainMenuAction.EXIT,
      label: 'logout',
      labelColor: Colors.redAccent,
      icon: Icons.exit_to_app,
      iconColor: Colors.redAccent),
];

final IconData _menuIcon = Icons.reorder;

class MainMenu {


  MainMenu (BuildContext context, String lang) {
    _bloc = context != null? SessionProvider.of(context) : null;
    _lang = lang;
  }

  SessionBloc _bloc;
  String _lang;

  void _onPopupMenuSelected(MainMenuAction item) {
    if (MainMenuAction.EXIT == item) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } if (MainMenuAction.ACCOUNT == item){
      _bloc.changeLanguage('ma');
    }
    else {
      // do nothing
    }
  }

  static get menuItems => _menuItems;
  static get menuIcon => _menuIcon;
  get language => _lang;
  

  get menu {
    Menu m = Menu<MainMenuAction>(lang: _lang);
    return [
      PopupMenuButton<MainMenuAction>(
          icon: Icon(_menuIcon),
          onSelected: _onPopupMenuSelected,
          itemBuilder: (BuildContext context) => m.toList(_menuItems))
    ];
  }
}
