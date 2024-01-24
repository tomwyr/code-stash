import 'package:appwrite_graphql_client/assets.dart';
import 'package:appwrite_graphql_client/models/types/medal_type.dart';

extension MedalTypeAsset on MedalType {
  String get asset {
    switch (this) {
      case MedalType.gold:
        return Assets.goldMedal;
      case MedalType.silver:
        return Assets.silverMedal;
      case MedalType.bronze:
        return Assets.bronzeMedal;
    }
  }
}
