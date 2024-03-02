class UnexpectedSealedTypeError extends Error {
  UnexpectedSealedTypeError(this.type, this.json);

  final Type type;
  final String? json;

  @override
  String toString() {
    return 'Json data that was supposed to be deserialized to a sealed type $type '
        'contains an unknown type value $json';
  }
}
