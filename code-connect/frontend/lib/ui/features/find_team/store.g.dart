// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FindTeamStore on _FindTeamStore, Store {
  late final _$_compositionAtom =
      Atom(name: '_FindTeamStore._composition', context: context);

  TeamComposition? get composition {
    _$_compositionAtom.reportRead();
    return super._composition;
  }

  @override
  TeamComposition? get _composition => composition;

  @override
  set _composition(TeamComposition? value) {
    _$_compositionAtom.reportWrite(value, super._composition, () {
      super._composition = value;
    });
  }

  late final _$_errorAtom =
      Atom(name: '_FindTeamStore._error', context: context);

  AppError? get error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  AppError? get _error => error;

  @override
  set _error(AppError? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$_loadingAtom =
      Atom(name: '_FindTeamStore._loading', context: context);

  bool get loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  bool get _loading => loading;

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
