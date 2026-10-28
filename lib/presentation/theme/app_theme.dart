import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _primary = Color(0xFF3F51B5);
  static const _darkPrimary = Color(0xFF303F9F);
  static const _lightPrimary = Color(0xFFC5CAE9);
  static const _accent = Color(0xFFFF5722);
  static const _text = Color(0xFF212121);
  static const _secondaryText = Color(0xFF757575);
  static const _divider = Color(0xFFBDBDBD);

  static final light = _theme(
    ColorScheme.fromSeed(seedColor: _primary).copyWith(
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: _lightPrimary,
      onPrimaryContainer: _text,
      secondary: _accent,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: _text,
      onSurfaceVariant: _secondaryText,
      outline: _divider,
    ),
    background: Colors.white,
  );

  static final dark = _theme(
    ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _darkPrimary,
      onPrimary: Colors.white,
      primaryContainer: _primary,
      onPrimaryContainer: Colors.white,
      secondary: _accent,
      onSecondary: Colors.white,
      surface: const Color(0xFF2B2B2B),
      onSurface: Colors.white,
      onSurfaceVariant: _divider,
      outline: _secondaryText,
    ),
    background: _text,
  );

  static ThemeData _theme(ColorScheme colors, {required Color background}) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: background,
    );
    return theme.copyWith(
      textTheme: theme.textTheme
          .apply(fontFamily: 'Roboto')
          .copyWith(
            headlineLarge: theme.textTheme.headlineLarge?.copyWith(
              letterSpacing: 0,
            ),
            headlineMedium: theme.textTheme.headlineMedium?.copyWith(
              letterSpacing: 0,
            ),
            titleLarge: theme.textTheme.titleLarge?.copyWith(letterSpacing: 0),
            bodyMedium: theme.textTheme.bodyMedium?.copyWith(letterSpacing: 0),
            bodySmall: theme.textTheme.bodySmall?.copyWith(letterSpacing: 0),
          ),
      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
