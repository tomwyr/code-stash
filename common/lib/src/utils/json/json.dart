typedef FromJson<T> = T Function(Map<String, dynamic> json);

final _fromJsons = <Type, FromJson>{};

void addJsonType<T>(FromJson<T> fromJson) {
  if (_fromJsons.containsKey(T)) {
    throw FromJsonAlreadyAddError(T);
  }
  _fromJsons[T] = fromJson;
}

FromJson<T> getFromJson<T>() {
  if (!_fromJsons.containsKey(T)) {
    throw FromJsonNotAddedError(T);
  }
  return _fromJsons[T] as FromJson<T>;
}

class FromJsonAlreadyAddError extends Error {
  FromJsonAlreadyAddError(this.type);

  final Type type;

  @override
  String toString() {
    return 'Another fromJson function has already been registered for type $type';
  }
}

class FromJsonNotAddedError extends Error {
  FromJsonNotAddedError(this.type);

  final Type type;

  @override
  String toString() {
    return 'No fromJson function has been registered for type $type';
  }
}
