import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appwrite_graphql_client/dependencies/dependencies.dart';
import 'medals_bloc.dart';
import 'medals_page.dart';
import 'medals_state.dart';

extension MedalsBuildContext on BuildContext {
  MedalsBloc get medalsBloc => read<MedalsBloc>();
  MedalsState get medalsState => watch<MedalsBloc>().state;
  T medalsSelect<T>(T Function(MedalsState state) selector) => select<MedalsState, T>(selector);
}

class MedalsComponent extends StatelessWidget {
  const MedalsComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => DI.createMedalsBloc()..onInit(),
        child: const MedalsPage(),
      );
}
