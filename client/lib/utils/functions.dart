import 'package:flutter/widgets.dart';

void runPostFrame(VoidCallback callback) {
  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) => callback());
}
