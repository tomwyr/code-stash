import 'package:appwrite_graphql_client/data/api/mutations/register_athlete.dart';
import 'package:appwrite_graphql_client/data/api/olympics_api.dart';
import 'package:appwrite_graphql_client/data/api/queries/athletes.dart';
import 'package:appwrite_graphql_client/data/api/subscriptions/athlete_registered.dart';
import 'package:appwrite_graphql_client/models/inputs/athlete_input.dart';
import 'package:appwrite_graphql_client/models/types/athlete.dart';
import 'package:appwrite_graphql_client/utils/extensions/future_extensions.dart';

class AthleteRepository {
  AthleteRepository({
    required this.olympicsApi,
  });

  final OlympicsApi olympicsApi;

  Future<List<Athlete>> getAthletes() async {
    return olympicsApi.requestMany(athletesQuery).thenMap(Athlete.fromJson);
  }

  Future<Athlete> registerAthlete(AthleteInput input) async {
    return olympicsApi
        .request(
          registerAthleteMutation,
          input: input.toJson(),
        )
        .then(Athlete.fromJson);
  }

  Stream<Athlete> observeAthleteRegistered() {
    return olympicsApi.observe(athleteRegisteredSubscription).map(Athlete.fromJson);
  }
}
