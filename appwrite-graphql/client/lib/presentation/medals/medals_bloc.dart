import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:appwrite_graphql_client/data/repositories/medal_repository.dart';
import 'package:appwrite_graphql_client/models/types/medal.dart';
import 'medals_state.dart';

class MedalsBloc extends Cubit<MedalsState> {
  MedalsBloc({
    required this.medalRepository,
  }) : super(const MedalsState.initial());

  final MedalRepository medalRepository;

  void onInit() async {
    _observeMedalAwarded();
    _refreshMedals();
  }

  void onRefresh() => _refreshMedals();

  void _observeMedalAwarded() {
    medalRepository.observeMedalAwarded().listen(_onMedalAwarded);
  }

  void _onMedalAwarded(Medal medal) {
    final updatedMedals = state.medals.toList()..insert(0, medal);

    emit(state.copyWith(
      medals: updatedMedals,
    ));
  }

  void _refreshMedals() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    try {
      final medals = await medalRepository.getMedals();

      emit(state.copyWith(
        medals: medals,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }
}
