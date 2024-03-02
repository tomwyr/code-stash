import 'package:flutter/material.dart';

import 'ui/app.dart';
import 'utils/json_types.dart';

void main() {
  registerJsonTypes();
  runApp(const App());
}
