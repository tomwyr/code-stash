import 'package:flutter/material.dart';

import '../register_athlete_component.dart';
import '../register_athlete_form.dart';

class LastNameFormField extends StatelessWidget {
  const LastNameFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        onChanged: context.registerAthleteBloc.onLastNameChange,
        decoration: InputDecoration(
          label: const Text('Last Name'),
          errorText: context.registerAthleteSelect((state) => state.lastNameError)?.message,
        ),
      );
}
