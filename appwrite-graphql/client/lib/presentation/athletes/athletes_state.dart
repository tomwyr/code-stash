import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:appwrite_graphql_client/models/types/athlete.dart';

part 'athletes_state.g.dart';

@CopyWith()
class AthletesState {
  const AthletesState({
    required this.isLoading,
    required this.athletes,
  });

  const AthletesState.initial()
      : this(
          isLoading: false,
          athletes: const [],
        );

  final bool isLoading;
  final List<Athlete> athletes;
}
