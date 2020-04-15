import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:focus/service/menu.dart';

enum TestAction { A1 }

void main() {
  test('Create menu item', () {
    MenuItem i = MenuItem(value: TestAction.A1, label: 'x', icon: Icons.add);
    expect(i.label, 'X');
    expect(i.isIcon(), true);
    expect(i.isDivider(), false);
  });


  test('Create invalid menu item', () {
    try {
      //ignore
      MenuItem i = MenuItem(label: 'x');
    } on Error catch (x) {
      expect(x.toString().indexOf('value != null') != -1, true);
    }

    try {
      MenuItem i = MenuItem(value: TestAction.A1);
    } on Error catch (x) {
      expect(x.toString().indexOf('label != null') != -1, true);
    }
  });

  test('Create menu divider', () {
    MenuItem i = MenuItem.divider();
    expect(i.isDivider(), true);
  });

  test('Create menu', () {
    List<MenuItem<TestAction>> items = [
      MenuItem(value: TestAction.A1, label: 'item1', icon: Icons.add),
      MenuItem.divider(),
      MenuItem(value: TestAction.A1, label: 'logout'),
    ];

    Menu m = Menu<TestAction>();
    List<PopupMenuEntry<TestAction>> l = m.toList(items);
    expect(l.length == 3, true);
    expect(l[1] is PopupMenuDivider, true);
  });
}
