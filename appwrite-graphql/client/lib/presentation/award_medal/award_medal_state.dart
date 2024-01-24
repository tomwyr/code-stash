import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:appwrite_graphql_client/models/types/athlete.dart';
import 'package:appwrite_graphql_client/models/types/discipline.dart';
import 'award_medal_form.dart';

part 'award_medal_state.g.dart';

@CopyWith()
class AwardMedalState {
  const AwardMedalState({
    required this.isLoading,
    required this.didAward,
    required this.disciplines,
    required this.athletes,
    required this.eventError,
    required this.medalTypeError,
    required this.disciplineError,
    required this.athleteError,
  });

  const AwardMedalState.initial()
      : this(
          isLoading: false,
          didAward: false,
          disciplines: const [],
          athletes: const [],
          eventError: null,
          medalTypeError: null,
          disciplineError: null,
          athleteError: null,
        );

  final bool isLoading;
  final bool didAward;
  final List<Discipline> disciplines;
  final List<Athlete> athletes;

  final AwardMedalFormError? eventError;
  final AwardMedalFormError? medalTypeError;
  final AwardMedalFormError? disciplineError;
  final AwardMedalFormError? athleteError;

  bool get canSubmit => [
        eventError,
        medalTypeError,
        disciplineError,
        athleteError,
      ].every((error) => error == null);
}
