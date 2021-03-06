import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus/service/menu.dart';
import 'package:focus/page/home/main_menu_widget.dart';
import 'package:focus/service/language.dart';

final String _lang = LANG_ENGLISH;

void main() {
  testWidgets('Main menu', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MockWidget());

    // Tap the menu icon and trigger dialog.
    await tester.tap(find.byIcon(MainMenu.menuIcon));
    await tester.pump();

    // Verify that the first menu item is shown.
    List<MenuItem<MainMenuAction>> items = MainMenu.menuItems;

    Language lang = Language(LANG_ENGLISH);
    expect(find.text('XXX'), findsNothing);
    expect(find.text(lang.label(items[0].label)), findsOneWidget);
  });
}

class MockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainMenu mm = MainMenu(context, null, Language(LANG_ENGLISH), null);
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('mock'), actions: mm.menu),
      ),
    );
  }
}
