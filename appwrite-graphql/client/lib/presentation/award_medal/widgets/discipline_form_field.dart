import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/discipline.dart';
import '../award_medal_component.dart';
import '../award_medal_form.dart';

class DisciplineFormField extends StatelessWidget {
  const DisciplineFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<Discipline>(
        decoration: InputDecoration(
          label: const Text('Discipline'),
          errorText: context.awardMedalSelect((state) => state.disciplineError)?.message,
        ),
        items: context.awardMedalSelect((state) => state.disciplines).map(_buildItem).toList(),
        onChanged: context.awardMedalBloc.onDisciplineChange,
      );

  DropdownMenuItem<Discipline> _buildItem(Discipline discipline) => DropdownMenuItem(
        value: discipline,
        child: Text(discipline.name),
      );
}
