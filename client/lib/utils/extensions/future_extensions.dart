extension FutureExtensions<T> on Future<List<T>> {
  Future<List<R>> thenMap<R>(R Function(T) mapper) => then((value) => value.map(mapper).toList());
}
