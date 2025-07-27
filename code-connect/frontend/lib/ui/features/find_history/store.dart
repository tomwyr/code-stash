import 'package:mobx/mobx.dart';

part 'store.g.dart';

class FindHistoryStore = _FindHistoryStore with _$FindHistoryStore;

abstract class _FindHistoryStore with Store {
  @readonly
  List<String> _history = [];

  Future<void> loadHistory() async {
    _history = [
      'TikTok for managers',
      'Electric skateboard renting business',
      'Showing interactive ads in virtual reality and ordering from web stores',
    ];
  }
}
