import 'package:json_annotation/json_annotation.dart';

import 'package:appwrite_graphql_client/models/types/gender.dart';
import 'package:appwrite_graphql_client/utils/typedefs.dart';

part 'athlete_input.g.dart';

@JsonSerializable()
class AthleteInput {
  AthleteInput({
    required this.name,
    required this.gender,
    required this.birthdate,
    required this.countryCode,
  });

  final String name;
  final Gender gender;
  final String birthdate;
  final String countryCode;

  JsonObject toJson() => _$AthleteInputToJson(this);

  static AthleteInput fromJson(JsonObject json) => _$AthleteInputFromJson(json);
}
