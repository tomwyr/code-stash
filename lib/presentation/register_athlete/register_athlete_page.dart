import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/utils/extensions/build_context_extensions.dart';
import 'package:appwrite_graphql_client/utils/functions.dart';
import 'register_athlete_component.dart';
import 'widgets/birthdate_form_field.dart';
import 'widgets/country_form_field.dart';
import 'widgets/first_name_form_field.dart';
import 'widgets/gender_form_field.dart';
import 'widgets/last_name_form_field.dart';
import 'widgets/submit_button.dart';

class RegisterAthletePage extends StatefulWidget {
  const RegisterAthletePage({Key? key}) : super(key: key);

  @override
  State<RegisterAthletePage> createState() => _RegisterAthletePageState();
}

class _RegisterAthletePageState extends State<RegisterAthletePage> {
  @override
  void initState() {
    super.initState();
    runPostFrame(_listenAthleteCreated);
  }

  void _listenAthleteCreated() async {
    await context.registerAthleteBloc.stream.where((state) => state.didRegister).take(1).drain();

    if (!mounted) return;

    context.pop();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 24),
          Text(
            'Register Athlete',
            style: Theme.of(context).textTheme.headline6,
          ),
          Visibility(
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            visible:
                context.registerAthleteSelect((state) => !state.isLoading && !state.didRegister),
            replacement: const CircularProgressIndicator(),
            child: _buildContent(),
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget _buildContent() => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            FirstNameFormField(),
            SizedBox(height: 8),
            LastNameFormField(),
            SizedBox(height: 8),
            GenderFormField(),
            SizedBox(height: 8),
            CountryFormField(),
            SizedBox(height: 8),
            BirthdateFormField(),
            SizedBox(height: 24),
            SubmitButton(),
          ],
        ),
      );
}
