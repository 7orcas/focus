import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus/service/language.dart';
import 'package:focus/service/menu.dart';
import 'package:focus/route.dart';

enum MainMenuAction { ABOUT, ACCOUNT, SETTINGS, en,mi,de, EXIT }

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
      value: MainMenuAction.EXIT,
      label: 'logout',
      labelColor: Colors.redAccent,
      icon: Icons.exit_to_app,
      iconColor: Colors.redAccent),
];

final IconData _menuIcon = Icons.reorder;

class MainMenu {
  MainMenu(BuildContext context, Function onChangeLanguage, String lang) {
    _context = context;
    _onChangeLanguage = onChangeLanguage;
    _lang = lang;
  }

  BuildContext _context;
  Function _onChangeLanguage;
  String _lang;

  void _onPopupMenuSelected(MainMenuAction item) {
    if (MainMenuAction.EXIT == item) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
  get language => _lang;

  get menu {
    Menu m = Menu<MainMenuAction>(_lang);
    return [
      PopupMenuButton<MainMenuAction>(
          icon: Icon(_menuIcon),
          onSelected: _onPopupMenuSelected,
          itemBuilder: (BuildContext context) => m.toList(_menuItems))
    ];
  }
}
