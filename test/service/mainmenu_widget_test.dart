import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus/service/menu.dart';
import 'package:focus/page/home/mainmenu.dart';

final MainMenu mm = MainMenu();

void main() {
  testWidgets('Main menu', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MockWidget());

    // Tap the menu icon and trigger dialog.
    await tester.tap(find.byIcon(mm.menuIcon));
    await tester.pump();

    // Verify that the first menu item is shown.
    List<MenuItem<MainMenuAction>> items = mm.menuItems;
    expect(find.text('XXX'), findsNothing);
    expect(find.text(items[0].label), findsOneWidget);
  });
}

class MockWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
            title: Text('mock'),
            actions: mm.menu
        ),
      ),
    );
  }
}