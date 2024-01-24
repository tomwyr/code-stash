import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/athlete.dart';
import 'package:appwrite_graphql_client/utils/extensions/country_icon.dart';
import 'package:appwrite_graphql_client/utils/extensions/gender_icon.dart';
import 'athletes_component.dart';

class AthletesPage extends StatelessWidget {
  const AthletesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.athletesState;

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.athletes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No athletes registered yet'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: context.athletesBloc.onRefresh,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.athletes.length,
      itemBuilder: (_, index) => _buildAthleteTile(state.athletes[index]),
    );
  }

  Widget _buildAthleteTile(Athlete athlete) => ListTile(
        leading: Icon(
          athlete.gender.icon,
          color: athlete.gender.color,
        ),
        title: Text(
          athlete.name,
        ),
        trailing: Image.asset(
          athlete.country.icon,
          package: CountryIcon.package,
          width: 24,
          height: 24,
        ),
      );
}
