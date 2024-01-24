import 'package:json_annotation/json_annotation.dart';

import 'package:appwrite_graphql_client/utils/typedefs.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  Country({
    required this.id,
    required this.name,
    required this.code,
  });

  final String id;
  final String name;
  final String code;

  static Country fromJson(JsonObject json) => _$CountryFromJson(json);

  JsonObject toJson() => _$CountryToJson(this);
}
