import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

List<PersistentBottomNavBarItem> items = [
  PersistentBottomNavBarItem(title: "Item1", icon: Icon(Icons.add)),
  PersistentBottomNavBarItem(title: "Item2", icon: Icon(Icons.add)),
  PersistentBottomNavBarItem(title: "Item3", icon: Icon(Icons.add)),
];

Widget defaultScreen(int id) => Container(child: Text("Screen$id"));

Widget screenWithButton(int id, void Function(BuildContext) onTap) => Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          defaultScreen(id),
          Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () => onTap(context),
              child: Text("SubPage"),
            );
          })
        ],
      ),
    );

void main() {
  Widget wrapTabView(WidgetBuilder builder) {
    return MaterialApp(
      home: Builder(
        builder: (context) => builder(context),
      ),
    );
  }

  group("pushNewScreen", () {
    testWidgets("pushes with navBar", (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3]
                .map((id) => screenWithButton(
                    id,
                    (context) => pushNewScreen(
                          context,
                          screen: defaultScreen(id * 10 + (id % 10)),
                          withNavBar: true,
                        )))
                .toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets("pushes without navBar", (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3]
                .map((id) => screenWithButton(
                    id,
                    (context) => pushNewScreen(
                          context,
                          screen: defaultScreen(id * 10 + (id % 10)),
                          withNavBar: false,
                        )))
                .toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsNothing);
    });
  });

  group("pushDynamicScreen", () {
    testWidgets("pushes with navBar", (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3]
                .map((id) => screenWithButton(
                    id,
                    (context) => pushDynamicScreen(
                          context,
                          screen: MaterialPageRoute(
                              builder: (context) =>
                                  defaultScreen(id * 10 + (id % 10))),
                          withNavBar: true,
                        )))
                .toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets("pushes without navBar", (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3]
                .map((id) => screenWithButton(
                    id,
                    (context) => pushDynamicScreen(
                          context,
                          screen: MaterialPageRoute(
                              builder: (context) =>
                                  defaultScreen(id * 10 + (id % 10))),
                          withNavBar: false,
                        )))
                .toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsNothing);
    });
  });

  group("pushNewScreenWithRouteSettings", () {
    testWidgets("pushes with navBar", (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3]
                .map((id) => screenWithButton(
                    id,
                    (context) => pushNewScreenWithRouteSettings(
                          context,
                          screen: defaultScreen(id * 10 + (id % 10)),
                          withNavBar: true,
                          settings: RouteSettings(),
                        )))
                .toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets("pushes without navBar", (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3]
                .map((id) => screenWithButton(
                    id,
                    (context) => pushNewScreenWithRouteSettings(
                          context,
                          screen: defaultScreen(id * 10 + (id % 10)),
                          withNavBar: false,
                          settings: RouteSettings(),
                        )))
                .toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsNothing);
    });
  });
}
