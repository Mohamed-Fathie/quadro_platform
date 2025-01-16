import 'package:flutter/material.dart';

class NavigationService {
  // Singleton pattern for global accessibility
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  // GlobalKey for NavigatorState
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a route by its name with optional arguments
  dynamic routeTo(String route, {Object? arguments}) {
    try {
      return navigatorKey.currentState?.pushNamed(route, arguments: arguments);
    } catch (e) {
      debugPrint('Navigation Error: $e');
    }
  }
  //final navService = NavigationService();
// navService.routeTo(RoutesConstants.signUp, arguments: {'name': 'John'});

  /// Replace the current route with a new one
  dynamic replaceRoute(String route, {Object? arguments}) {
    try {
      return navigatorKey.currentState
          ?.pushReplacementNamed(route, arguments: arguments);
    } catch (e) {
      debugPrint('Navigation Error: $e');
    }
  }
  //final navService = NavigationService();
//navService.replaceRoute(RoutesConstants.home);

  /// Navigate to a route and clear the navigation stack
  dynamic clearAndNavigateTo(String route, {Object? arguments}) {
    try {
      return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        route,
        (route) => false,
        arguments: arguments,
      );
    } catch (e) {
      debugPrint('Navigation Error: $e');
    }
  }
  //  //final navService = NavigationService();
// navService.clearAndNavigateTo(RoutesConstants.login);

  /// Navigate back with an optional result
  void goBack<T>({T? result}) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop(result);
    } else {
      debugPrint('No routes in the navigation stack to pop.');
    }
  }
  //navService.goBack(result: 'Returned Data');

  /// Check if a route can pop
  bool canGoBack() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
  //if (navService.canGoBack()) {
  // navService.goBack();
}
