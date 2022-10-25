import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

List<PersistentBottomNavBarItem> items = [
  PersistentBottomNavBarItem(title: "Item1", icon: Icon(Icons.add)),
  PersistentBottomNavBarItem(title: "Item2", icon: Icon(Icons.add)),
  PersistentBottomNavBarItem(title: "Item3", icon: Icon(Icons.add)),
];

Widget defaultScreen(int id) => Container(child: Text("Screen$id"));

void main() {
  Widget wrapTabView(WidgetBuilder builder) {
    return MaterialApp(
      home: Builder(
        builder: (context) => builder(context),
      ),
    );
  }

  testStyle(WidgetTester tester, NavBarStyle style) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          context,
          screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
          items: items,
          navBarStyle: style,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
        ),
      ),
    );

    expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);
  }

  testWidgets('builds every style', (WidgetTester tester) async {
    for (NavBarStyle style in NavBarStyle.values) {
      await testStyle(tester, style);
    }
  });
}
