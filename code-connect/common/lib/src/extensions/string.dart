extension StringEncoder on String {
  String get uriEncoded {
    return Uri.encodeComponent(this).replaceAll('+', '%20');
  }
}
