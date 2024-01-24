import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:appwrite_graphql_client/models/types/medal.dart';

part 'medals_state.g.dart';

@CopyWith()
class MedalsState {
  const MedalsState({
    required this.isLoading,
    required this.medals,
  });

  const MedalsState.initial()
      : this(
          isLoading: false,
          medals: const [],
        );

  final bool isLoading;
  final List<Medal> medals;
}
