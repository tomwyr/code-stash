import 'package:json_annotation/json_annotation.dart';

@JsonEnum(
  fieldRename: FieldRename.pascal,
)
enum MedalType {
  gold,
  silver,
  bronze,
}
