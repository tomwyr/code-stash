import 'package:json_annotation/json_annotation.dart';

import '../data/appwrite.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.name,
  });

  @idKey
  final String id;
  final String name;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
