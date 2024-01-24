import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/medal_type.dart';
import 'package:appwrite_graphql_client/presentation/app/widgets/radio_form_field.dart';
import 'package:appwrite_graphql_client/utils/extensions/medal_type_asset.dart';
import '../award_medal_component.dart';
import '../award_medal_form.dart';

class MedalTypeFormField extends StatelessWidget {
  const MedalTypeFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => RadioFormField<MedalType>(
        onChanged: context.awardMedalBloc.onMedalTypeChange,
        decoration: InputDecoration(
          label: const Text('Medal Type'),
          errorText: context.awardMedalSelect((state) => state.medalTypeError)?.message,
        ),
        items: MedalType.values.map(_buildItem).toList(),
      );

  RadioItem<MedalType> _buildItem(MedalType medalType) => RadioItem(
        value: medalType,
        child: Image.asset(
          medalType.asset,
          width: 48,
          height: 48,
        ),
      );
}
