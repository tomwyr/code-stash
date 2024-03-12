import 'package:flutter/material.dart';

import '../features/find_team/page.dart';
import '../widgets/error_displayer.dart';
import 'error.dart';
import 'layout.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.errorHandler,
  });

  final AppErrorHandler errorHandler;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      builder: (context, child) => ErrorDisplayer(
        onInit: errorHandler.init,
        child: AppLayout(
          child: child!,
        ),
      ),
      home: FindTeamPage(),
    );
  }
}
