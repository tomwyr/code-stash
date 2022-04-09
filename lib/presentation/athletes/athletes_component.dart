import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appwrite_graphql_client/dependencies/dependencies.dart';
import 'athletes_bloc.dart';
import 'athletes_page.dart';
import 'athletes_state.dart';

extension AthletesBuildContext on BuildContext {
  AthletesBloc get athletesBloc => read<AthletesBloc>();
  AthletesState get athletesState => watch<AthletesBloc>().state;
}

class AthletesComponent extends StatelessWidget {
  const AthletesComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => DI.createAthletesBloc()..onInit(),
        child: const AthletesPage(),
      );
}
