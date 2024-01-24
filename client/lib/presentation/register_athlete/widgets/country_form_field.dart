import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/country.dart';
import 'package:appwrite_graphql_client/utils/extensions/country_icon.dart';
import '../register_athlete_component.dart';
import '../register_athlete_form.dart';

class CountryFormField extends StatelessWidget {
  const CountryFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<Country>(
        decoration: InputDecoration(
          label: const Text('Country'),
          errorText: context.registerAthleteSelect((state) => state.countryError)?.message,
        ),
        items: context.registerAthleteSelect((state) => state.countries).map(_buildItem).toList(),
        onChanged: context.registerAthleteBloc.onCountryChange,
      );

  DropdownMenuItem<Country> _buildItem(Country country) => DropdownMenuItem(
        value: country,
        child: Row(
          children: [
            Image.asset(
              country.icon,
              package: CountryIcon.package,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 12),
            Text(country.name),
          ],
        ),
      );
}
