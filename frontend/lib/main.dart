import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ui/app/app.dart';
import 'ui/app/error.dart';
import 'utils/env.dart';
import 'utils/json_types.dart';

void main() {
  runAppGuarded(before: () async {
    await loadEnv();
    registerJsonTypes();
  });
}

void runAppGuarded({required AsyncCallback before}) {
  final errorHandler = AppErrorHandler();
  final app = App(errorHandler: errorHandler);
  runZonedGuarded(() async {
    await before();
    runApp(app);
  }, errorHandler);
}
