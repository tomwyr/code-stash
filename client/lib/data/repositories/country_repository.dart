import 'package:appwrite_graphql_client/data/api/olympics_api.dart';
import 'package:appwrite_graphql_client/data/api/queries/countries.dart';
import 'package:appwrite_graphql_client/models/types/country.dart';
import 'package:appwrite_graphql_client/utils/extensions/future_extensions.dart';

class CountryRepository {
  CountryRepository({
    required this.olympicsApi,
  });

  final OlympicsApi olympicsApi;

  Future<List<Country>> getCountries() async {
    return olympicsApi.requestMany(countriesQuery).thenMap(Country.fromJson);
  }
}
