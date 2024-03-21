import 'package:flutter/material.dart';

ThemeData get appTheme => ThemeData().copyWith(
      textTheme: Typography.material2021(colorScheme: colorScheme).black,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: colors.canvas,
      colorScheme: colorScheme,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.complementary,
        selectionHandleColor: colors.complementary,
        selectionColor: colors.complementary.withOpacity(0.25),
      ),
      inputDecorationTheme: InputDecorationTheme(
        activeIndicatorBorder: BorderSide(color: colors.complementary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(192, 48),
        ),
      ),
      bannerTheme: MaterialBannerThemeData(
        contentTextStyle: TextStyle(
          color: colors.onBrand,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: colors.background,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colors.background,
      ),
    );

ColorScheme get colorScheme => ColorScheme.light(
      surface: colors.complementary,
      onSurface: colors.brand,
      primary: colors.onBrand,
    );

AppColors get colors => AppColors();

class AppColors {
  final brand = Color(0xff001a3b);
  final complementary = Color(0xffffce90);
  final onBrand = Colors.black;
  final background = Colors.white;
  final hint = Colors.grey;
  final canvas = Colors.grey[50]!;
  final card = Colors.grey[200]!;
}
