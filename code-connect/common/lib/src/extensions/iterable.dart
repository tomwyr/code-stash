import 'package:rust_core/result.dart';

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> distinct() => toSet();
}

extension FlattenResults<S, F extends Object> on Iterable<Future<Result<S, F>>> {
  Future<Result<List<S>, F>> flatten() async {
    final result = <S>[];

    for (var next in this) {
      switch (await next) {
        case Ok(:var ok):
          result.add(ok);
        case Err(:var err):
          return err.toErr();
      }
    }

    return result.toOk();
  }
}
