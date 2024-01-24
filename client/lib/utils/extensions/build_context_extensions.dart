import 'package:flutter/widgets.dart';

extension BuildContextExtensions on BuildContext {
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}
