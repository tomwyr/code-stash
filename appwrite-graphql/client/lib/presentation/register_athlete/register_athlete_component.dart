import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appwrite_graphql_client/dependencies/dependencies.dart';
import 'register_athlete_bloc.dart';
import 'register_athlete_page.dart';
import 'register_athlete_state.dart';

extension RegisterAthleteBuildContext on BuildContext {
  RegisterAthleteBloc get registerAthleteBloc => read<RegisterAthleteBloc>();
  RegisterAthleteState get registerAthleteState => watch<RegisterAthleteBloc>().state;
  T registerAthleteSelect<T>(T Function(RegisterAthleteState state) selector) =>
      select<RegisterAthleteState, T>(selector);
}

class RegisterAthleteComponent extends StatelessWidget {
  const RegisterAthleteComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => DI.createRegisterAthleteBloc()..onInit(),
        child: const RegisterAthletePage(),
      );
}
