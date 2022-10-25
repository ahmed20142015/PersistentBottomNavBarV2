part of persistent_bottom_nav_bar_v2;

class RouteAndNavigatorSettings {
  final String? defaultTitle;

  final Map<String, WidgetBuilder>? routes;

  final RouteFactory? onGenerateRoute;

  final RouteFactory? onUnknownRoute;

  final String? initialRoute;

  final List<NavigatorObserver> navigatorObservers;

  final GlobalKey<NavigatorState>? navigatorKey;

  const RouteAndNavigatorSettings({
    this.defaultTitle,
    this.routes,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.initialRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.navigatorKey,
  });

  RouteAndNavigatorSettings copyWith({
    String? defaultTitle,
    Map<String, WidgetBuilder>? routes,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    String? initialRoute,
    List<NavigatorObserver>? navigatorObservers,
    GlobalKey<NavigatorState>? navigatorKeys,
  }) {
    return RouteAndNavigatorSettings(
      defaultTitle: defaultTitle ?? this.defaultTitle,
      routes: routes ?? this.routes,
      onGenerateRoute: onGenerateRoute ?? this.onGenerateRoute,
      onUnknownRoute: onUnknownRoute ?? this.onUnknownRoute,
      initialRoute: initialRoute ?? this.initialRoute,
      navigatorObservers: navigatorObservers ?? this.navigatorObservers,
      navigatorKey: navigatorKey ?? this.navigatorKey,
    );
  }
}

class CustomWidgetRouteAndNavigatorSettings {
  final String? defaultTitle;

  final Map<String, WidgetBuilder>? routes;

  final RouteFactory? onGenerateRoute;

  final RouteFactory? onUnknownRoute;

  final String? initialRoute;

  /// Each tab in your [PersistenBottomNavBar.custom] requires its own list of [NavigatorObserver]. As soon as you want to put a [NavigatorObserver] to one of your tabs, you need to set the list of observers for each tab. Of course, if you dont need observers for all tabs, the sublists can be empty too. All of this is ignored if you just leave the list empty, which is the default.
  /// Usage example (3 tabs, [Navigator] of the first and last should be observed):
  /// ```dart
  /// CustomWidgetRouteAndNavigatorSettings(
  ///   navigatorObservers: [[NavigatorObserver()], [], [NavigatorObserver()]]
  /// )
  /// ```
  final List<List<NavigatorObserver>> navigatorObservers;

  final List<GlobalKey<NavigatorState>>? navigatorKeys;

  const CustomWidgetRouteAndNavigatorSettings({
    this.defaultTitle,
    this.routes,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.initialRoute,
    this.navigatorObservers = const <List<NavigatorObserver>>[],
    this.navigatorKeys,
  });

  CustomWidgetRouteAndNavigatorSettings copyWith({
    String? defaultTitle,
    Map<String, WidgetBuilder>? routes,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    String? initialRoute,
    List<List<NavigatorObserver>>? navigatorObservers,
    List<GlobalKey<NavigatorState>>? navigatorKeys,
  }) {
    return CustomWidgetRouteAndNavigatorSettings(
      defaultTitle: defaultTitle ?? this.defaultTitle,
      routes: routes ?? this.routes,
      onGenerateRoute: onGenerateRoute ?? this.onGenerateRoute,
      onUnknownRoute: onUnknownRoute ?? this.onUnknownRoute,
      initialRoute: initialRoute ?? this.initialRoute,
      navigatorObservers: navigatorObservers ?? this.navigatorObservers,
      navigatorKeys: navigatorKeys ?? this.navigatorKeys,
    );
  }
}
