import 'package:flutter/material.dart';

import 'ui/app.dart';
import 'utils/env.dart';
import 'utils/json_types.dart';

void main() async {
  await loadEnv();
  registerJsonTypes();
  runApp(const App());
}
