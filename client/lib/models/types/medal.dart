import 'package:json_annotation/json_annotation.dart';

import 'package:appwrite_graphql_client/utils/typedefs.dart';
import 'athlete.dart';
import 'discipline.dart';
import 'medal_type.dart';

part 'medal.g.dart';

@JsonSerializable()
class Medal {
  Medal({
    required this.date,
    required this.event,
    required this.type,
    required this.athlete,
    required this.discipline,
  });

  final String date;
  final String event;
  final MedalType type;
  final Athlete athlete;
  final Discipline discipline;

  static Medal fromJson(JsonObject json) => _$MedalFromJson(json);

  JsonObject toJson() => _$MedalToJson(this);
}
