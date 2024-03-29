// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FindHistoryStore on _FindHistoryStore, Store {
  late final _$_historyAtom =
      Atom(name: '_FindHistoryStore._history', context: context);

  List<String> get history {
    _$_historyAtom.reportRead();
    return super._history;
  }

  @override
  List<String> get _history => history;

  @override
  set _history(List<String> value) {
    _$_historyAtom.reportWrite(value, super._history, () {
      super._history = value;
    });
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
