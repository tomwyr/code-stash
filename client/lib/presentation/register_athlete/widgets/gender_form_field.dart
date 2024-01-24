import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/gender.dart';
import 'package:appwrite_graphql_client/presentation/app/widgets/radio_form_field.dart';
import 'package:appwrite_graphql_client/utils/extensions/gender_icon.dart';
import '../register_athlete_component.dart';
import '../register_athlete_form.dart';

class GenderFormField extends StatelessWidget {
  const GenderFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => RadioFormField<Gender>(
        onChanged: context.registerAthleteBloc.onGenderChange,
        decoration: InputDecoration(
          label: const Text('Gender'),
          errorText: context.registerAthleteSelect((state) => state.genderError)?.message,
        ),
        items: Gender.values.map(_buildItem).toList(),
      );

  RadioItem<Gender> _buildItem(Gender gender) => RadioItem(
        value: gender,
        child: Icon(
          gender.icon,
          size: 48,
        ),
      );
}
