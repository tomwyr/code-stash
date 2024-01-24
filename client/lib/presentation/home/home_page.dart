import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/assets.dart';
import 'package:appwrite_graphql_client/presentation/athletes/athletes_component.dart';
import 'package:appwrite_graphql_client/presentation/medals/medals_component.dart';
import 'widgets/home_bottom_navigation_bar.dart';
import 'widgets/home_floating_action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Image.asset(
            Assets.olympicsLogo,
            height: 32,
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            AthletesComponent(),
            MedalsComponent(),
          ],
        ),
        floatingActionButton: const HomeFloatingActionButton(),
        bottomNavigationBar: HomeBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      );
}
