import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006769),
      surfaceTint: Color(0xff00696c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff008285),
      onPrimaryContainer: Color(0xfff2ffff),
      secondary: Color(0xff3f6566),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbfe7e8),
      onSecondaryContainer: Color(0xff43696a),
      tertiary: Color(0xff714c8f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8b64aa),
      onTertiaryContainer: Color(0xfffffbff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff5fafa),
      onSurface: Color(0xff171d1d),
      onSurfaceVariant: Color(0xff3d4949),
      outline: Color(0xff6d797a),
      outlineVariant: Color(0xffbcc9c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3131),
      inversePrimary: Color(0xff68d7db),
      primaryFixed: Color(0xff86f4f8),
      onPrimaryFixed: Color(0xff002021),
      primaryFixedDim: Color(0xff68d7db),
      onPrimaryFixedVariant: Color(0xff004f52),
      secondaryFixed: Color(0xffc2eaeb),
      onSecondaryFixed: Color(0xff002021),
      secondaryFixedDim: Color(0xffa6cecf),
      onSecondaryFixedVariant: Color(0xff264d4e),
      tertiaryFixed: Color(0xfff2daff),
      onTertiaryFixed: Color(0xff2c044a),
      tertiaryFixedDim: Color(0xffe0b6ff),
      onTertiaryFixedVariant: Color(0xff5b3678),
      surfaceDim: Color(0xffd6dbdb),
      surfaceBright: Color(0xfff5fafa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5f4),
      surfaceContainer: Color(0xffeaefee),
      surfaceContainerHigh: Color(0xffe4e9e9),
      surfaceContainerHighest: Color(0xffdee3e3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff68d7db),
      surfaceTint: Color(0xff68d7db),
      onPrimary: Color(0xff003738),
      primaryContainer: Color(0xff21a0a4),
      onPrimaryContainer: Color(0xff002324),
      secondary: Color(0xffa6cecf),
      onSecondary: Color(0xff0c3637),
      secondaryContainer: Color(0xff264d4e),
      onSecondaryContainer: Color(0xff95bcbe),
      tertiary: Color(0xffe0b6ff),
      onTertiary: Color(0xff431f60),
      tertiaryContainer: Color(0xffa980c8),
      onTertiaryContainer: Color(0xff30094d),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1414),
      onSurface: Color(0xffdee3e3),
      onSurfaceVariant: Color(0xffbcc9c9),
      outline: Color(0xff879393),
      outlineVariant: Color(0xff3d4949),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e3),
      inversePrimary: Color(0xff00696c),
      primaryFixed: Color(0xff86f4f8),
      onPrimaryFixed: Color(0xff002021),
      primaryFixedDim: Color(0xff68d7db),
      onPrimaryFixedVariant: Color(0xff004f52),
      secondaryFixed: Color(0xffc2eaeb),
      onSecondaryFixed: Color(0xff002021),
      secondaryFixedDim: Color(0xffa6cecf),
      onSecondaryFixedVariant: Color(0xff264d4e),
      tertiaryFixed: Color(0xfff2daff),
      onTertiaryFixed: Color(0xff2c044a),
      tertiaryFixedDim: Color(0xffe0b6ff),
      onTertiaryFixedVariant: Color(0xff5b3678),
      surfaceDim: Color(0xff0f1414),
      surfaceBright: Color(0xff353a3a),
      surfaceContainerLowest: Color(0xff0a0f0f),
      surfaceContainerLow: Color(0xff171d1d),
      surfaceContainer: Color(0xff1b2121),
      surfaceContainerHigh: Color(0xff262b2b),
      surfaceContainerHighest: Color(0xff303636),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surfaceContainer,
    canvasColor: colorScheme.surface,

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surfaceTint,
      centerTitle: true,
    )
  );
}

