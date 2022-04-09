extension StringExtenstions on String {
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map(_capitalize).join(' ');

  String _capitalize(String value) => this[0].toUpperCase() + substring(1).toLowerCase();
}
