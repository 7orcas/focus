import 'package:flutter/material.dart';
import 'package:focus/service/language.dart';

// Menu item
class MenuItem<T> {
  MenuItem({@required value, @required label, labelColor, icon, iconColor}) {
    assert(value != null);
    assert(label != null);
    _value = value;
    _label = label;
    _labelColor = labelColor != null ? labelColor : Colors.black;
    _icon = icon;
    _iconColor = iconColor != null ? iconColor : Colors.black;
  }

  MenuItem.divider() {
    _divider = true;
  }

  String toString() {
    if (isDivider()) return 'divider';
    return 'value=' +
        _value.toString() +
        ', label=' +
        _label +
        ', labelColor=' +
        _labelColor.toString() +
        ', icon=' +
        (_icon == null ? 'null' : _icon.toString()) +
        ', iconColor=' +
        _iconColor.toString();
  }

  T _value;
  String _label;
  IconData _icon;
  Color _labelColor;
  Color _iconColor;
  bool _divider = false;

  get value => _value;
  get label => _label;
  get labelColor => _labelColor;
  get icon => _icon;
  get iconColor => _iconColor;

  bool isIcon() => _icon != null;
  bool isDivider() => _divider;
}


// Control construction of menu
class Menu<T> {

  Menu ({@required lang}) : _lang = lang;

  String _lang;


  //Return list of menu items
  List<PopupMenuEntry<T>> toList(List<MenuItem> items) {
    Language lang = Language(_lang);
    List<PopupMenuEntry<T>> list = [];
    items.forEach((item) {
      if (item.isDivider()) {
        list.add(PopupMenuDivider());
      } else {
        //Get menu item attributes
        List<Widget> w = [
          Text(
            lang.label(item.label),
            style: TextStyle(color: item.labelColor),
          )
        ];
        if (item.isIcon()) {
          w.insert(0, SizedBox(width: 10));
          w.insert(0, Icon(item.icon, color: item.iconColor));
        }

        list.add(PopupMenuItem<T>(
          value: item.value,
          child: Row(children: w),
        ));
      }
    });
    return list;
  }
}
