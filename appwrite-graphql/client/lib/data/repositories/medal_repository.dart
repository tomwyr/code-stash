import 'package:appwrite_graphql_client/data/api/mutations/award_medal.dart';
import 'package:appwrite_graphql_client/data/api/olympics_api.dart';
import 'package:appwrite_graphql_client/data/api/queries/medals.dart';
import 'package:appwrite_graphql_client/data/api/subscriptions/medal_awarded.dart';
import 'package:appwrite_graphql_client/models/inputs/medal_input.dart';
import 'package:appwrite_graphql_client/models/types/medal.dart';
import 'package:appwrite_graphql_client/utils/extensions/future_extensions.dart';

class MedalRepository {
  MedalRepository({
    required this.olympicsApi,
  });

  final OlympicsApi olympicsApi;

  Future<List<Medal>> getMedals() {
    return olympicsApi.requestMany(medalsQuery).thenMap(Medal.fromJson);
  }

  Future<Medal> awardMedal(MedalInput input) {
    return olympicsApi
        .request(
          awardMedalMutation,
          input: input.toJson(),
        )
        .then(Medal.fromJson);
  }

  Stream<Medal> observeMedalAwarded() {
    return olympicsApi.observe(medalAwardedSubscription).map(Medal.fromJson);
  }
}
