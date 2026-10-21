import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF0F766E); // calm teal — reads as "money" without being garish

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
  );
}
