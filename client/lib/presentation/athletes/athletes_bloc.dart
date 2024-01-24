import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appwrite_graphql_client/data/repositories/athlete_repository.dart';
import 'package:appwrite_graphql_client/models/types/athlete.dart';
import 'athletes_state.dart';

class AthletesBloc extends Cubit<AthletesState> {
  AthletesBloc({
    required this.athleteRepository,
  }) : super(const AthletesState.initial());

  final AthleteRepository athleteRepository;

  void onInit() async {
    _observeAthleteRegistered();
    _refreshAthletes();
  }

  void onRefresh() => _refreshAthletes();

  void _observeAthleteRegistered() {
    athleteRepository.observeAthleteRegistered().listen(_onAthleteRegistered);
  }

  void _onAthleteRegistered(Athlete athlete) {
    final updatedAthletes = state.athletes.toList()..insert(0, athlete);

    emit(state.copyWith(
      athletes: updatedAthletes,
    ));
  }

  void _refreshAthletes() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    try {
      final athletes = await athleteRepository.getAthletes();

      emit(state.copyWith(
        athletes: athletes,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }
}
