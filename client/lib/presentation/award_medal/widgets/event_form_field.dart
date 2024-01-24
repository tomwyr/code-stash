import 'package:flutter/material.dart';

import '../award_medal_component.dart';
import '../award_medal_form.dart';

class EventFormField extends StatelessWidget {
  const EventFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        onChanged: context.awardMedalBloc.onEventChange,
        decoration: InputDecoration(
          label: const Text('Event'),
          errorText: context.awardMedalSelect((state) => state.eventError)?.message,
        ),
      );
}
