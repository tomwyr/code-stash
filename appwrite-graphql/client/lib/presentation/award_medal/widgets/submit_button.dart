import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/presentation/award_medal/award_medal_component.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: context.awardMedalSelect((state) => state.canSubmit)
            ? context.awardMedalBloc.onSubmit
            : null,
        child: const Text('Submit'),
      );
}
