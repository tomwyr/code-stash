import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/presentation/home/home_page.dart';
import 'themes/app_theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: AppThemes.createDefault(),
        home: const HomeScreen(),
      );
}
