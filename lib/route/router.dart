import 'package:fluent_ui/fluent_ui.dart';
import 'package:galgame_toolbox/route/route_constants.dart';
import 'package:galgame_toolbox/screens/dashboard.dart';
import 'package:galgame_toolbox/screens/about.dart';
import 'package:galgame_toolbox/screens/launcher.dart';
import 'package:galgame_toolbox/screens/settings.dart';
import 'package:galgame_toolbox/screens/shortcut.dart';
import 'package:go_router/go_router.dart';

import '../screens/app_home/home_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return AppHomePage(
        shellContext: _shellNavigatorKey.currentContext,
        child: child,
      );
    },
    routes: <GoRoute>[
      /// Home
      GoRoute(path: '/', builder: (context, state) => const Launcher()),
      ///  Dashboard
      GoRoute(path: RouteConstants.dashboard.routePath, builder: (context, state) => const Dashboard()),
      /// Shortcuts
      GoRoute(
        path: '/shortcut/:groupId',
        builder: (context, state) {
          final groupId = state.pathParameters['groupId'];
          return Shortcut(group: groupId ?? '-1');
        },
      ),
      /// Settings
      GoRoute(path: RouteConstants.settings.routePath, builder: (context, state) => const Settings()),
      // About
      GoRoute(path: RouteConstants.about.routePath, builder: (context, state) => const AboutPage()),
    ],
  ),
]);
