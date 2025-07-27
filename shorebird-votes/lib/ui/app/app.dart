import 'package:flutter/material.dart';

import '../pages/issues.dart';
import '../pages/login.dart';
import '../pages/splash.dart';
import '../pages/stats.dart';
import 'theme.dart';
import 'widgets/auth_navigator.dart';
import 'widgets/update_notifier.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      navigatorKey: _navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/issues': (_) => const IssuesPage(),
        '/stats': (_) => const StatsPage(),
      },
      builder: (context, child) => AuthNavigator(
        navigatorKey: _navigatorKey,
        child: UpdateNotifier(
          child: child!,
        ),
      ),
    );
  }
}
