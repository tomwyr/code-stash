extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> distinct() => toSet();
}

extension GenericExtensions<T> on T {
  R let<R>(R Function(T value) block) => block(this);
}
