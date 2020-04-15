import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus/service/menu.dart';

enum MainMenuAction { ABOUT, ACCOUNT, SETTINGS, EXIT }

final List<MenuItem<MainMenuAction>> _menuItems = [
  MenuItem(value: MainMenuAction.ABOUT, label: 'item1', icon: Icons.add),
  MenuItem(value: MainMenuAction.ACCOUNT, label: 'item2', icon: Icons.label),
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
  void _onPopupMenuSelected(MainMenuAction item) {
    if (MainMenuAction.EXIT == item) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      // do nothing
    }
  }

  get menuItems => _menuItems;
  get menuIcon => _menuIcon;
  
  final Menu m = Menu<MainMenuAction>();

  get menu {
    return [
      PopupMenuButton<MainMenuAction>(
          icon: Icon(_menuIcon),
          onSelected: _onPopupMenuSelected,
          itemBuilder: (BuildContext context) => m.toList(_menuItems))
    ];
  }
}
