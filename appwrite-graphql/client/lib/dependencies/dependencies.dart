import 'package:graphql/client.dart';

import 'package:appwrite_graphql_client/data/api/olympics_api.dart';
import 'package:appwrite_graphql_client/data/repositories/athlete_repository.dart';
import 'package:appwrite_graphql_client/data/repositories/country_repository.dart';
import 'package:appwrite_graphql_client/data/repositories/discipline_repository.dart';
import 'package:appwrite_graphql_client/data/repositories/medal_repository.dart';
import 'package:appwrite_graphql_client/presentation/athletes/athletes_bloc.dart';
import 'package:appwrite_graphql_client/presentation/award_medal/award_medal_bloc.dart';
import 'package:appwrite_graphql_client/presentation/medals/medals_bloc.dart';
import 'package:appwrite_graphql_client/presentation/register_athlete/register_athlete_bloc.dart';

abstract class DI {
  DI._();

  static _createGraphQLLink() {
    final httpLink = HttpLink(OlympicsApi.httpUrl);
    final webSocketLink = WebSocketLink(
      OlympicsApi.webSocketUrl,
      config: const SocketClientConfig(),
    );

    return Link.split((request) => request.isSubscription, webSocketLink, httpLink);
  }

  static final _graphQLClient = GraphQLClient(
    link: _createGraphQLLink(),
    cache: GraphQLCache(),
  );

  static final _olympicsApi = OlympicsApi(
    graphQLClient: _graphQLClient,
  );

  static final _medalRepository = MedalRepository(
    olympicsApi: _olympicsApi,
  );

  static final _athleteRepository = AthleteRepository(
    olympicsApi: _olympicsApi,
  );

  static final _countryRepository = CountryRepository(
    olympicsApi: _olympicsApi,
  );

  static final _disciplinesRepository = DisciplineRepository(
    olympicsApi: _olympicsApi,
  );

  static MedalsBloc createMedalsBloc() => MedalsBloc(
        medalRepository: _medalRepository,
      );

  static AthletesBloc createAthletesBloc() => AthletesBloc(
        athleteRepository: _athleteRepository,
      );

  static RegisterAthleteBloc createRegisterAthleteBloc() => RegisterAthleteBloc(
        countryRepository: _countryRepository,
        athleteRepository: _athleteRepository,
      );

  static AwardMedalBloc createAwardMedalBloc() => AwardMedalBloc(
        medalRepository: _medalRepository,
        athleteRepository: _athleteRepository,
        disciplineRepository: _disciplinesRepository,
      );
}
