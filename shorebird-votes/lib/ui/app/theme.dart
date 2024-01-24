import 'package:flutter/material.dart';

final appTheme = createAppTheme();

ThemeData createAppTheme() {
  final theme = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0x000057cc),
    ),
  );

  return theme.copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
    ),
  );
}
