import 'package:flutter/material.dart';

import '../register_athlete_component.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: context.registerAthleteSelect((state) => state.canSubmit)
            ? context.registerAthleteBloc.onSubmit
            : null,
        child: const Text('Submit'),
      );
}
