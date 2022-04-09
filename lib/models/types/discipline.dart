import 'package:json_annotation/json_annotation.dart';

import 'package:appwrite_graphql_client/utils/typedefs.dart';

part 'discipline.g.dart';

@JsonSerializable()
class Discipline {
  Discipline({
    required this.id,
    required this.name,
    required this.code,
  });

  final String id;
  final String name;
  final String code;

  static Discipline fromJson(JsonObject json) => _$DisciplineFromJson(json);

  JsonObject toJson() => _$DisciplineToJson(this);
}
