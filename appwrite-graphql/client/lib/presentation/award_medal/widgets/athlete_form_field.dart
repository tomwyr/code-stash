import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/athlete.dart';
import 'package:appwrite_graphql_client/utils/extensions/country_icon.dart';
import '../award_medal_component.dart';
import '../award_medal_form.dart';

class AthleteFormField extends StatelessWidget {
  const AthleteFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<Athlete>(
        decoration: InputDecoration(
          label: const Text('Athlete'),
          errorText: context.awardMedalSelect((state) => state.athleteError)?.message,
        ),
        items: context.awardMedalSelect((state) => state.athletes).map(_buildItem).toList(),
        onChanged: context.awardMedalBloc.onAthleteChange,
      );

  DropdownMenuItem<Athlete> _buildItem(Athlete athlete) => DropdownMenuItem(
        value: athlete,
        child: Row(
          children: [
            Image.asset(
              athlete.country.icon,
              package: CountryIcon.package,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 12),
            Text(athlete.name),
          ],
        ),
      );
}
