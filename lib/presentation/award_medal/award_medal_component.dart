import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appwrite_graphql_client/dependencies/dependencies.dart';
import 'award_medal_bloc.dart';
import 'award_medal_page.dart';
import 'award_medal_state.dart';

extension AwardMedalBuildContext on BuildContext {
  AwardMedalBloc get awardMedalBloc => read<AwardMedalBloc>();
  AwardMedalState get awardMedalState => watch<AwardMedalBloc>().state;
  T awardMedalSelect<T>(T Function(AwardMedalState state) selector) =>
      select<AwardMedalState, T>(selector);
}

class AwardMedalComponent extends StatelessWidget {
  const AwardMedalComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => DI.createAwardMedalBloc()..onInit(),
        child: const AwardMedalPage(),
      );
}
