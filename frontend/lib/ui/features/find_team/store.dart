import 'package:code_connect_common/code_connect_common.dart';
import 'package:mobx/mobx.dart';
import 'package:rust_core/src/result/result.dart';

import '../../../data/api.dart';

part 'store.g.dart';

class FindTeamStore = _FindTeamStore with _$FindTeamStore;

abstract class _FindTeamStore with Store {
  final teamFinder = CodeConnectApi();

  @readonly
  TeamComposition? _composition;

  @readonly
  TeamFinderError? _error;

  @readonly
  bool _loading = false;

  Future<void> findTeam(String projectDescription) async {
    _loading = true;
    try {
      final result = await await teamFinder.find(projectDescription);
      switch (result) {
        case Ok(:var ok):
          _composition = ok;
        case Err(:var err):
          _error = err;
      }
    } finally {
      _loading = false;
    }
  }
}
