import 'package:json_annotation/json_annotation.dart';

import 'package:appwrite_graphql_client/utils/typedefs.dart';
import 'country.dart';
import 'gender.dart';

part 'athlete.g.dart';

@JsonSerializable()
class Athlete {
  Athlete({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthdate,
    required this.country,
  });

  final String id;
  final String name;
  final Gender gender;
  final String birthdate;
  final Country country;

  static Athlete fromJson(JsonObject json) => _$AthleteFromJson(json);

  JsonObject toJson() => _$AthleteToJson(this);
}
