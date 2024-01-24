import 'package:appwrite_graphql_client/data/api/olympics_api.dart';
import 'package:appwrite_graphql_client/data/api/queries/disciplines.dart';
import 'package:appwrite_graphql_client/models/types/discipline.dart';
import 'package:appwrite_graphql_client/utils/extensions/future_extensions.dart';

class DisciplineRepository {
  DisciplineRepository({
    required this.olympicsApi,
  });

  final OlympicsApi olympicsApi;

  Future<List<Discipline>> getDisciplines() {
    return olympicsApi.requestMany(disciplinesQuery).thenMap(Discipline.fromJson);
  }
}
