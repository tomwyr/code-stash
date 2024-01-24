import 'package:json_annotation/json_annotation.dart';

import 'package:appwrite_graphql_client/models/types/medal_type.dart';
import 'package:appwrite_graphql_client/utils/typedefs.dart';

part 'medal_input.g.dart';

@JsonSerializable()
class MedalInput {
  MedalInput({
    required this.event,
    required this.type,
    required this.disciplineCode,
    required this.athleteId,
  });

  final String event;
  final MedalType type;
  final String disciplineCode;
  final String athleteId;

  JsonObject toJson() => _$MedalInputToJson(this);

  static MedalInput fromJson(JsonObject json) => _$MedalInputFromJson(json);
}
