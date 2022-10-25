import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

List<PersistentBottomNavBarItem> items = [
  PersistentBottomNavBarItem(title: "Item1", icon: Icon(Icons.add)),
  PersistentBottomNavBarItem(title: "Item2", icon: Icon(Icons.add)),
  PersistentBottomNavBarItem(title: "Item3", icon: Icon(Icons.add)),
];

Widget defaultScreen(int id) => Container(child: Text("Screen$id"));

Widget screenWithSubPages(int id) => id > 99
    ? defaultScreen(id)
    : Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            defaultScreen(id),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          screenWithSubPages(id * 10 + (id % 10))),
                ),
                child: Text("SubPage"),
              );
            })
          ],
        ),
      );

Future<void> tapAndroidBackButton(WidgetTester tester) async {
  final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
  await widgetsAppState.didPopRoute();
  await tester.pumpAndSettle();
}

void main() {
  Widget wrapTabView(WidgetBuilder builder) {
    return MaterialApp(
      home: Builder(
        builder: (context) => builder(context),
      ),
    );
  }

  group('PersistentTabView', () {
    testWidgets('builds a PersistentBottomNavBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets('can switch through tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );

      expect(find.text('Screen1'), findsOneWidget);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsNothing);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsNothing);
      expect(find.text('Screen2'), findsOneWidget);
      expect(find.text('Screen3'), findsNothing);
      await tester.tap(find.text("Item3"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsNothing);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsOneWidget);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsNothing);
    });

    testWidgets('hides the navbar when hideNavBar is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            hideNavigationBar: true,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsNothing);
    });

    testWidgets(
        'hides the navbar when hideNavigationBarWhenKeyboardShows is true and keyboard is up',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            hideNavigationBarWhenKeyboardShows: true,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return PersistentTabView(
                context,
                screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
                items: items,
                navBarStyle: NavBarStyle.style3,
                hideNavigationBarWhenKeyboardShows: true,
              );
            }),
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsNothing);
    });

    testWidgets(
        'does not hide navbar when hideNavigationBarWhenKeyboardShows is false and keyboard is up',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            hideNavigationBarWhenKeyboardShows: false,
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return PersistentTabView(
                context,
                screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
                items: items,
                navBarStyle: NavBarStyle.style3,
                hideNavigationBarWhenKeyboardShows: false,
              );
            }),
          ),
        ),
      );

      expect(find.byType(PersistentBottomNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets("sizes the navbar according to navBarHeight",
        (WidgetTester tester) async {
      double height = 42;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            navBarHeight: height,
          ),
        ),
      );

      expect(tester.getSize(find.byType(PersistentBottomNavBar)).height,
          equals(height));
    });

    testWidgets("puts padding around the navbar specified by margin",
        (WidgetTester tester) async {
      EdgeInsets margin = EdgeInsets.zero;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            margin: margin,
          ),
        ),
      );

      expect(
          Offset(0, 600) -
              tester.getBottomLeft(find.byType(PersistentBottomNavBar)),
          equals(margin.bottomLeft));
      expect(
          Offset(800, 600 - 56) -
              tester.getTopRight(find.byType(PersistentBottomNavBar)),
          equals(margin.topRight));

      margin = EdgeInsets.fromLTRB(12, 10, 8, 6);

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            margin: margin,
          ),
        ),
      );

      expect(
          tester.getBottomLeft(find
                  .descendant(
                      of: find.byType(PersistentBottomNavBar),
                      matching: find.byType(Container))
                  .first) -
              Offset(0, 600),
          equals(margin.bottomLeft));
      expect(
          tester.getTopRight(find
                  .descendant(
                      of: find.byType(PersistentBottomNavBar),
                      matching: find.byType(Container))
                  .first) -
              Offset(800, 600 - 56 - margin.vertical),
          equals(margin.topRight));
    });

    testWidgets("navbar is colored by backgroundColor",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            backgroundColor: Colors.amber,
          ),
        ),
      );

      expect(
          ((tester.firstWidget((find.descendant(
                      of: find.byType(PersistentBottomNavBar),
                      matching: find.byType(Container)))) as Container)
                  .decoration as BoxDecoration)
              .color,
          Colors.amber);
    });

    testWidgets("executes onItemSelected when tapping items",
        (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            onItemSelected: (index) => count++,
          ),
        ),
      );

      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(count, 1);
      await tester.tap(find.text("Item3"));
      await tester.pumpAndSettle();
      expect(count, 2);
    });

    testWidgets("executes onWillPop when exiting", (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            onWillPop: (context) async {
              count++;
              return true;
            },
          ),
        ),
      );

      await tapAndroidBackButton(tester);

      expect(count, 1);
    });

    group("should handle Android back button press and thus", () {
      testWidgets("switches to first tab on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              context,
              screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
              items: items,
              navBarStyle: NavBarStyle.style3,
              handleAndroidBackButtonPress: true,
            ),
          ),
        );

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
        await tester.tap(find.text("Item2"));
        await tester.pumpAndSettle();
        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
      });

      testWidgets("pops one screen on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              context,
              screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
              items: items,
              navBarStyle: NavBarStyle.style3,
              handleAndroidBackButtonPress: true,
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen11'), findsNothing);
      });
    });

    group("should not handle Android back button press and thus", () {
      testWidgets("does not switch to first tab on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              context,
              screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
              items: items,
              navBarStyle: NavBarStyle.style3,
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
        await tester.tap(find.text("Item2"));
        await tester.pumpAndSettle();
        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);
      });

      testWidgets("pops no screen on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              context,
              screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
              items: items,
              navBarStyle: NavBarStyle.style3,
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);
      });
    });

    testWidgets("navBarPadding adds padding inside navBar",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            padding: NavBarPadding.all(0),
          ),
        ),
      );
      double originalIconSize = tester.getSize(find.byType(Icon).first).height;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            padding: NavBarPadding.all(4),
          ),
        ),
      );
      expect(tester.getSize(find.byType(Icon).first).height,
          equals(originalIconSize - 4 * 2));
    });
    testWidgets("navBarPadding does not make navbar bigger",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            padding: NavBarPadding.all(4),
          ),
        ),
      );

      expect(tester.getSize(find.byType(PersistentBottomNavBar)).height,
          equals(kBottomNavigationBarHeight));
    });

    testWidgets(
        'resizes screens to avoid bottom inset according to resizeToAvoidBottomInset',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return PersistentTabView(
                context,
                screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
                items: items,
                navBarStyle: NavBarStyle.style3,
                resizeToAvoidBottomInset: true,
              );
            }),
          ),
        ),
      );

      expect(tester.getSize(find.byType(PersistentTabScaffold)).height,
          equals(500));

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return PersistentTabView(
                context,
                screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
                items: items,
                navBarStyle: NavBarStyle.style3,
                resizeToAvoidBottomInset: false,
              );
            }),
          ),
        ),
      );

      expect(tester.getSize(find.byType(PersistentTabScaffold)).height,
          equals(600));
    });

    testWidgets('resizes screens by bottomScreenMargin',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            bottomScreenMargin: kBottomNavigationBarHeight,
          ),
        ),
      );

      expect(tester.getSize(find.byKey(Key("TabSwitchingView"))).height,
          equals(600 - kBottomNavigationBarHeight));
    });

    testWidgets(
        'returns current screen context through selectedTabScreenContext',
        (WidgetTester tester) async {
      BuildContext? screenContext;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            selectedTabScreenContext: (context) => screenContext = context,
          ),
        ),
      );

      expect(screenContext?.findAncestorWidgetOfExactType<Offstage>()?.offstage,
          isFalse);
      BuildContext? oldContext = screenContext;
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(screenContext, isNot(equals(oldContext)));
      expect(screenContext?.findAncestorWidgetOfExactType<Offstage>()?.offstage,
          isFalse);
    });

    testWidgets('pops screens when tapping same tab if specified to do so',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            popAllScreensOnTapOfSelectedTab: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            popAllScreensOnTapOfSelectedTab: false,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
    });

    testWidgets('pops all screens when tapping same tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            popAllScreensOnTapOfSelectedTab: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen111"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen111"), findsNothing);
    });

    testWidgets('persists screens while switching if stateManagement turned on',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            stateManagement: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
    });

    testWidgets('trashes screens while switching if stateManagement turned off',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            stateManagement: false,
            screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen1"), findsOneWidget);
    });

    testWidgets('shows FloatingActionButton if specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton).hitTestable(), findsOneWidget);
    });

    testWidgets(
        "style16 and style17 center button are tappable above the navBar",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style16,
          ),
        ),
      );

      Offset topCenter =
          tester.getRect(find.byType(PersistentBottomNavBar)).topCenter;
      await tester.tapAt(topCenter.translate(0, -10));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style17,
          ),
        ),
      );

      topCenter = tester.getRect(find.byType(PersistentBottomNavBar)).topCenter;
      await tester.tapAt(topCenter.translate(0, -10));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
    });
  });

  group('PersistentTabView.custom', () {
    testWidgets('builds a PersistentBottomNavBar', (WidgetTester tester) async {
      await tester.pumpWidget(wrapTabView((context) => CustomView()));

      expect(find.byKey(Key("customNavBar")).hitTestable(), findsOneWidget);
    });

    testWidgets('can switch through tabs', (WidgetTester tester) async {
      await tester.pumpWidget(wrapTabView((context) => CustomView()));

      expect(find.text('Screen1'), findsOneWidget);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsNothing);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsNothing);
      expect(find.text('Screen2'), findsOneWidget);
      expect(find.text('Screen3'), findsNothing);
      await tester.tap(find.text("Item3"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsNothing);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsOneWidget);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsNothing);
    });

    testWidgets('hides the navbar when hideNavBar is true',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(wrapTabView((context) => CustomView(hideNavBar: true)));

      await tester.pumpAndSettle();

      expect(find.byKey(Key("customNavBar")).hitTestable(), findsNothing);
    });

    testWidgets(
        'hides the navbar when hideNavigationBarWhenKeyboardShows is true and keyboard is up',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            hideNavigationBarWhenKeyboardShows: true,
          ),
        ),
      );

      expect(find.byKey(Key("customNavBar")).hitTestable(), findsOneWidget);

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(
              builder: (context) => CustomView(
                hideNavigationBarWhenKeyboardShows: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key("customNavBar")).hitTestable(), findsNothing);
    });

    testWidgets(
        'does not hide navbar when hideNavigationBarWhenKeyboardShows is false and keyboard is up',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            hideNavigationBarWhenKeyboardShows: false,
          ),
        ),
      );

      expect(find.byKey(Key("customNavBar")).hitTestable(), findsOneWidget);

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(
              builder: (context) => CustomView(
                hideNavigationBarWhenKeyboardShows: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key("customNavBar")).hitTestable(), findsOneWidget);
    });

    testWidgets("sizes the navbar according to navBarHeight",
        (WidgetTester tester) async {
      double height = 42;

      await tester.pumpWidget(
        wrapTabView((context) => CustomView(
              navBarHeight: height,
            )),
      );

      expect(tester.getSize(find.byKey(Key("customNavBar"))).height,
          equals(height));
    });

    testWidgets("puts padding around the navbar specified by margin",
        (WidgetTester tester) async {
      EdgeInsets margin = EdgeInsets.zero;

      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            margin: margin,
          ),
        ),
      );

      expect(
          Offset(0, 600) -
              tester.getBottomLeft(find.byKey(Key("customNavBar"))),
          equals(margin.bottomLeft));
      expect(
          Offset(800, 600 - 56) -
              tester.getTopRight(find.byKey(Key("customNavBar"))),
          equals(margin.topRight));

      margin = EdgeInsets.fromLTRB(12, 10, 8, 6);

      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            margin: margin,
          ),
        ),
      );

      expect(
          tester.getBottomLeft(find.byKey(Key("customNavBar"))) -
              Offset(0, 600),
          equals(margin.bottomLeft));
      expect(
          tester.getTopRight(find.byKey(Key("customNavBar"))) -
              Offset(800, 600 - 56 - margin.vertical),
          equals(margin.topRight));
    });
    testWidgets("backgroundColor is shown behind the navBar",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            backgroundColor: Colors.amber,
          ),
        ),
      );

      expect(
          ((tester.firstWidget(
            (find.descendant(
              of: find.byType(PersistentBottomNavBar),
              matching: find.byType(Container),
            )),
          ) as Container)
              .color as Color),
          Colors.amber);
    });
    group("should handle Android back button press and thus", () {
      testWidgets("switches to first tab on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => CustomView(
              handleAndroidBackButtonPress: true,
            ),
          ),
        );

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
        await tester.tap(find.text("Item2"));
        await tester.pumpAndSettle();
        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
      });

      testWidgets("pops one screen on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => CustomView(
              handleAndroidBackButtonPress: true,
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen11'), findsNothing);
      });
    });

    group("should not handle Android back button press and thus", () {
      testWidgets("does not switch to first tab on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => CustomView(
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
        await tester.tap(find.text("Item2"));
        await tester.pumpAndSettle();
        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);
      });

      testWidgets("pops no screen on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => CustomView(
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);
      });
    });

    testWidgets(
        'resizes screens to avoid bottom inset according to resizeToAvoidBottomInset',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return CustomView(
                resizeToAvoidBottomInset: true,
              );
            }),
          ),
        ),
      );

      expect(tester.getSize(find.byType(PersistentTabScaffold)).height,
          equals(500));

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return CustomView(
                resizeToAvoidBottomInset: false,
              );
            }),
          ),
        ),
      );

      expect(tester.getSize(find.byType(PersistentTabScaffold)).height,
          equals(600));
    });

    testWidgets('resizes screens by bottomScreenMargin',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            bottomScreenMargin: kBottomNavigationBarHeight,
          ),
        ),
      );

      expect(tester.getSize(find.byKey(Key("TabSwitchingView"))).height,
          equals(600 - kBottomNavigationBarHeight));
    });
    testWidgets('pops screens when tapping same tab if specified to do so',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            popAllScreensOnTapOfSelectedTab: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);

      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            popAllScreensOnTapOfSelectedTab: false,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
    });
    testWidgets('pops all screens when tapping same tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            popAllScreensOnTapOfSelectedTab: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen111"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen111"), findsNothing);
    });

    testWidgets('persists screens while switching if stateManagement turned on',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            stateManagement: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
    });

    testWidgets('trashes screens while switching if stateManagement turned off',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
            items: items,
            navBarStyle: NavBarStyle.style3,
            stateManagement: false,
            screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen1"), findsOneWidget);
    });

    testWidgets('shows FloatingActionButton if specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => CustomView(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton).hitTestable(), findsOneWidget);
    });
  });

  group("Regression", () {
    testWidgets("#31 one navbar border side does not throw error",
        (widgetTester) async {
      await widgetTester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            context,
            screens: [1, 2, 3].map((id) => defaultScreen(id)).toList(),
            items: items,
            decoration: const NavBarDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      );
    });
  });
}

class CustomView extends StatefulWidget {
  final bool hideNavBar;
  final bool hideNavigationBarWhenKeyboardShows;
  final double navBarHeight;
  final EdgeInsets margin;
  final Color backgroundColor;
  final bool handleAndroidBackButtonPress;
  final bool resizeToAvoidBottomInset;
  final bool popAllScreensOnTapOfSelectedTab;
  final double? bottomScreenMargin;
  final bool stateManagement;
  final Widget? floatingActionButton;

  CustomView({
    this.hideNavBar = false,
    this.hideNavigationBarWhenKeyboardShows = true,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.margin = EdgeInsets.zero,
    this.backgroundColor = CupertinoColors.white,
    this.handleAndroidBackButtonPress = true,
    this.resizeToAvoidBottomInset = true,
    this.bottomScreenMargin,
    this.popAllScreensOnTapOfSelectedTab = true,
    this.stateManagement = true,
    this.floatingActionButton,
  });

  @override
  State<CustomView> createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: PersistentTabView.custom(
        context,
        screens: [1, 2, 3].map((id) => screenWithSubPages(id)).toList(),
        items: items,
        itemCount: 3,
        hideNavigationBar: widget.hideNavBar,
        hideNavigationBarWhenKeyboardShows:
            widget.hideNavigationBarWhenKeyboardShows,
        navBarHeight: widget.navBarHeight,
        margin: widget.margin,
        backgroundColor: widget.backgroundColor,
        handleAndroidBackButtonPress: widget.handleAndroidBackButtonPress,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        bottomScreenMargin: widget.bottomScreenMargin,
        popAllScreensOnTapOfSelectedTab: widget.popAllScreensOnTapOfSelectedTab,
        stateManagement: widget.stateManagement,
        floatingActionButton: widget.floatingActionButton,
        customWidget: (navBarEssentials) => Container(
          key: Key("customNavBar"),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              ...items
                  .map((item) => Container(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              navBarEssentials
                                  .onItemSelected!(items.indexOf(item));
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              item.icon,
                              Text(item.title ?? "Unknown"),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
