import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:appwrite_graphql_client/presentation/award_medal/award_medal_component.dart';
import 'package:appwrite_graphql_client/presentation/register_athlete/register_athlete_component.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          _buildSpeedDialItem(
            context: context,
            icon: Icons.person_add,
            label: 'Register athlete',
            content: const RegisterAthleteComponent(),
          ),
          _buildSpeedDialItem(
            context: context,
            icon: Icons.new_label,
            label: 'Award medal',
            content: const AwardMedalComponent(),
          ),
        ],
      );

  SpeedDialChild _buildSpeedDialItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Widget content,
  }) =>
      SpeedDialChild(
        child: Icon(icon),
        label: label,
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => SingleChildScrollView(
            child: content,
          ),
        ),
      );
}
