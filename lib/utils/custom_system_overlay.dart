import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility for configuring system UI overlay colors consistently across the app.
class CustomSystemOverlay {
  const CustomSystemOverlay._();

  /// Returns a [SystemUiOverlayStyle] with the provided colors and automatically
  /// calculated icon brightness for readability.
  static SystemUiOverlayStyle style({
    required Color statusBarColor,
    required Color navigationBarColor,
    Color? navigationBarDividerColor,
  }) {
    final statusIcons = _iconBrightnessFor(statusBarColor);
    final navIcons = _iconBrightnessFor(navigationBarColor);

    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: statusIcons,
      statusBarBrightness: _opposite(statusIcons),
      systemNavigationBarColor: navigationBarColor,
      systemNavigationBarIconBrightness: navIcons,
      systemNavigationBarDividerColor:
          navigationBarDividerColor ?? navigationBarColor,
    );
  }

  /// Applies the overlay style immediately using [SystemChrome].
  static void apply({
    required Color statusBarColor,
    required Color navigationBarColor,
    Color? navigationBarDividerColor,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      style(
        statusBarColor: statusBarColor,
        navigationBarColor: navigationBarColor,
        navigationBarDividerColor: navigationBarDividerColor,
      ),
    );
  }

  static Brightness _iconBrightnessFor(Color color) {
    // A higher luminance means the color is lighter; use dark icons on light backgrounds.
    return color.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light;
  }

  static Brightness _opposite(Brightness brightness) {
    return brightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }
}
