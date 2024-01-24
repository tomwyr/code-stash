import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/medal.dart';
import 'package:appwrite_graphql_client/utils/extensions/country_icon.dart';
import 'package:appwrite_graphql_client/utils/extensions/medal_type_asset.dart';
import 'medals_component.dart';

class MedalsPage extends StatelessWidget {
  const MedalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.medalsState;

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.medals.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No medals awarded yet'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: context.medalsBloc.onRefresh,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.medals.length,
      itemBuilder: (_, index) => _buildMedalTile(state.medals[index]),
    );
  }

  Widget _buildMedalTile(Medal medal) => ListTile(
        leading: Image.asset(
          medal.type.asset,
          width: 24,
          height: 24,
        ),
        trailing: Image.asset(
          medal.athlete.country.icon,
          package: CountryIcon.package,
          width: 24,
          height: 24,
        ),
        title: Text(
          medal.athlete.name,
        ),
      );
}
