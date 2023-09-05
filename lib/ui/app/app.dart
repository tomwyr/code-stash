import 'package:flutter/material.dart';

import '../pages/issues.dart';
import '../pages/login.dart';
import '../pages/splash.dart';
import 'auth_navigator.dart';
import 'theme.dart';

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
      },
      builder: (context, child) => AuthNavigator(
        navigatorKey: _navigatorKey,
        child: child!,
      ),
    );
  }
}
