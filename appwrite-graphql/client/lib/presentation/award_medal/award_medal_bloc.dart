import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appwrite_graphql_client/data/repositories/athlete_repository.dart';
import 'package:appwrite_graphql_client/data/repositories/discipline_repository.dart';
import 'package:appwrite_graphql_client/data/repositories/medal_repository.dart';
import 'package:appwrite_graphql_client/models/inputs/medal_input.dart';
import 'package:appwrite_graphql_client/models/types/athlete.dart';
import 'package:appwrite_graphql_client/models/types/discipline.dart';
import 'package:appwrite_graphql_client/models/types/medal_type.dart';
import 'award_medal_form.dart';
import 'award_medal_state.dart';

class AwardMedalBloc extends Cubit<AwardMedalState> {
  AwardMedalBloc({
    required this.medalRepository,
    required this.athleteRepository,
    required this.disciplineRepository,
  }) : super(const AwardMedalState.initial());

  final MedalRepository medalRepository;
  final AthleteRepository athleteRepository;
  final DisciplineRepository disciplineRepository;

  String? _event;
  MedalType? _medalType;
  Discipline? _discipline;
  Athlete? _athlete;

  void onInit() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    try {
      final athletes = await athleteRepository.getAthletes();
      final disciplines = await disciplineRepository.getDisciplines();

      emit(state.copyWith(
        athletes: athletes,
        disciplines: disciplines,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }

  void onEventChange(String? value) {
    _event = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      eventError: error,
    ));
  }

  void onMedalTypeChange(MedalType? value) {
    _medalType = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      medalTypeError: error,
    ));
  }

  void onDisciplineChange(Discipline? value) {
    _discipline = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      disciplineError: error,
    ));
  }

  void onAthleteChange(Athlete? value) {
    _athlete = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      athleteError: error,
    ));
  }

  void onSubmit() {
    if (state.didAward) return;

    _validateEmptyInputs();

    if (!state.canSubmit) return;

    _awardMedal();
  }

  void _validateEmptyInputs() {
    if (_event == null) onEventChange(_event);
    if (_medalType == null) onMedalTypeChange(_medalType);
    if (_discipline == null) onDisciplineChange(_discipline);
    if (_athlete == null) onAthleteChange(_athlete);
  }

  AwardMedalFormError? _validateNotEmpty<T>(T? value) {
    final isEmpty = value == null || (value is String && value.isEmpty);

    return isEmpty ? AwardMedalFormError.valueEmpty : null;
  }

  void _awardMedal() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    try {
      final input = _createMedalInput();

      await medalRepository.awardMedal(input);

      emit(state.copyWith(
        didAward: true,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }

  MedalInput _createMedalInput() => MedalInput(
        event: _event!,
        type: _medalType!,
        disciplineCode: _discipline!.code,
        athleteId: _athlete!.id,
      );
}
