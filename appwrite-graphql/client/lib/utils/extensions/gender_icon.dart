import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/models/types/gender.dart';

extension GenderIcon on Gender {
  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.man;
      case Gender.female:
        return Icons.woman;
    }
  }

  Color get color {
    switch (this) {
      case Gender.male:
        return Colors.blue[300]!;
      case Gender.female:
        return Colors.pink[300]!;
    }
  }
}
