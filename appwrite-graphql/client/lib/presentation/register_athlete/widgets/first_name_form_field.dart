import 'package:flutter/material.dart';

import '../register_athlete_component.dart';
import '../register_athlete_form.dart';

class FirstNameFormField extends StatelessWidget {
  const FirstNameFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        onChanged: context.registerAthleteBloc.onFirstNameChange,
        decoration: InputDecoration(
          label: const Text('First Name'),
          errorText: context.registerAthleteSelect((state) => state.firstNameError)?.message,
        ),
      );
}
