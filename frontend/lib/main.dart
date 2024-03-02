import 'package:flutter/material.dart';

import 'ui/app.dart';
import 'utils/env.dart';
import 'utils/json_types.dart';

void main() async {
  Env.init();
  registerJsonTypes();
  runApp(const App());
}
