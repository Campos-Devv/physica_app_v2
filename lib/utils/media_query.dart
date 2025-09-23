import 'package:flutter/material.dart';

/// Device size breakpoints with custom base widths
enum DeviceSize { xs, sm, md, lg, xl, xxl }

/// BuildContext extension with responsive helpers.
/// Use: context.responsive(16), context.responsiveHeight(120)
extension MediaQueryX on BuildContext {
  // Core
  MediaQueryData get _mq => MediaQuery.of(this);
  Size get _size => _mq.size;

  // Dimensions
  double get screenWidth => _size.width;
  double get screenHeight => _size.height;

  // Safe insets
  EdgeInsets get padding => _mq.padding;
  double get topPadding => padding.top;
  double get bottomPadding => padding.bottom;
  double get leftPadding => padding.left;
  double get rightPadding => padding.right;

  double get safeWidth => screenWidth - leftPadding - rightPadding;
  double get safeHeight => screenHeight - topPadding - bottomPadding;

  // Info
  double get pixelRatio => _mq.devicePixelRatio;
  double get textScale => _mq.textScaler.scale(1.0);
  Orientation get orientation => _mq.orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // Device class
  bool get isTablet => _size.shortestSide >= 600;
  bool get isPhone => !isTablet;

  // UPDATED BREAKPOINT SYSTEM WITH CUSTOM BASE WIDTHS
  DeviceSize get deviceSize {
    final width = screenWidth;
    if (width <= 320) return DeviceSize.xs;     // Small phones (0-320px)
    if (width <= 370) return DeviceSize.sm;     // Medium phones (321-370px)
    if (width <= 425) return DeviceSize.md;     // Large phones (371-425px)
    if (width <= 768) return DeviceSize.lg;     // Tablets (426-768px)
    if (width <= 1020) return DeviceSize.xl;    // Small desktops (769-1020px)
    return DeviceSize.xxl;                      // Large desktops (1021px+)
  }

  // Base dimensions for each breakpoint
  Size get _baseSize {
    switch (deviceSize) {
      case DeviceSize.xs:
        return const Size(320.0, 568.0);   // Small phones (iPhone SE)
      case DeviceSize.sm:
        return const Size(370.0, 667.0);   // Medium phones (iPhone 8)
      case DeviceSize.md:
        return const Size(425.0, 812.0);   // Large phones (iPhone X+)
      case DeviceSize.lg:
        return const Size(768.0, 1024.0);  // Tablets (iPad)
      case DeviceSize.xl:
        return const Size(1020.0, 720.0);  // Small desktops
      case DeviceSize.xxl:
        return const Size(1440.0, 900.0);  // Large desktops
    }
  }

  // Individual base width/height getters
  double get _baseWidth => _baseSize.width;
  double get _baseHeight => _baseSize.height;

  // COMBINED SCALING FACTORS
  double get _widthScale => screenWidth / _baseWidth;
  double get _heightScale => screenHeight / _baseHeight;
  
  /// Combined scale factor using the smaller of width/height scales
  /// This ensures proportional scaling without overflow
  double get _combinedScale => _widthScale < _heightScale ? _widthScale : _heightScale;
  
  /// Average scale factor for balanced scaling
  double get _averageScale => (_widthScale + _heightScale) / 2;

  // Breakpoint checkers
  bool get isXs => deviceSize == DeviceSize.xs;
  bool get isSm => deviceSize == DeviceSize.sm;
  bool get isMd => deviceSize == DeviceSize.md;
  bool get isLg => deviceSize == DeviceSize.lg;
  bool get isXl => deviceSize == DeviceSize.xl;
  bool get isXxl => deviceSize == DeviceSize.xxl;

  // Range checkers (updated thresholds)
  bool get isSmAndUp => screenWidth > 320;
  bool get isMdAndUp => screenWidth > 370;
  bool get isLgAndUp => screenWidth > 425;
  bool get isXlAndUp => screenWidth > 768;
  bool get isXxlAndUp => screenWidth > 1020;

  bool get isXsAndDown => screenWidth <= 320;
  bool get isSmAndDown => screenWidth <= 370;
  bool get isMdAndDown => screenWidth <= 425;
  bool get isLgAndDown => screenWidth <= 768;
  bool get isXlAndDown => screenWidth <= 1020;

  // Percent helpers
  double widthPercent(double percent) => screenWidth * (percent / 100);
  double heightPercent(double percent) => screenHeight * (percent / 100);
  double safeWidthPercent(double percent) => safeWidth * (percent / 100);
  double safeHeightPercent(double percent) => safeHeight * (percent / 100);

  // ENHANCED RESPONSIVE METHODS WITH COMBINED SCALING

  /// Enhanced responsive scaling with combined width/height consideration
  double responsive(double value, {
    double? baseWidth,  // Optional override
    double? baseHeight, // Optional override
    ResponsiveMode mode = ResponsiveMode.combined, // Scaling mode
    double? xs,  // Small phones (0-320px)
    double? sm,  // Medium phones (321-370px)
    double? md,  // Large phones (371-425px)
    double? lg,  // Tablets (426-768px)
    double? xl,  // Small desktops (769-1020px)
    double? xxl, // Large desktops (1021px+)
  }) {
    // If breakpoint-specific value is provided, use it
    switch (deviceSize) {
      case DeviceSize.xs:
        if (xs != null) return xs;
        break;
      case DeviceSize.sm:
        if (sm != null) return sm;
        break;
      case DeviceSize.md:
        if (md != null) return md;
        break;
      case DeviceSize.lg:
        if (lg != null) return lg;
        break;
      case DeviceSize.xl:
        if (xl != null) return xl;
        break;
      case DeviceSize.xxl:
        if (xxl != null) return xxl;
        break;
    }
    
    // Calculate scale factor based on mode
    double scaleFactor;
    switch (mode) {
      case ResponsiveMode.widthOnly:
        scaleFactor = baseWidth != null 
          ? screenWidth / baseWidth 
          : _widthScale;
        break;
      case ResponsiveMode.heightOnly:
        scaleFactor = baseHeight != null 
          ? screenHeight / baseHeight 
          : _heightScale;
        break;
      case ResponsiveMode.combined:
        scaleFactor = _combinedScale;
        break;
      case ResponsiveMode.average:
        scaleFactor = _averageScale;
        break;
    }
    
    return value * scaleFactor;
  }

  /// Width-based responsive scaling (legacy method)
  double responsiveWidth(double value, {
    double? baseWidth,
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsive(value, 
    baseWidth: baseWidth, mode: ResponsiveMode.widthOnly,
    xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Height-based responsive scaling (legacy method)
  double responsiveHeight(double value, {
    double? baseHeight,
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsive(value, 
    baseHeight: baseHeight, mode: ResponsiveMode.heightOnly,
    xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Combined responsive scaling (recommended for most UI elements)
  double responsiveCombined(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsive(value, 
    mode: ResponsiveMode.combined,
    xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Average responsive scaling (good for fonts and padding)
  double responsiveAverage(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsive(value, 
    mode: ResponsiveMode.average,
    xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Quick breakpoint-based value selector
  T breakpoint<T>({
    T? xs,   // Small phones (0-320px)
    T? sm,   // Medium phones (321-370px)
    T? md,   // Large phones (371-425px)
    T? lg,   // Tablets (426-768px)
    T? xl,   // Small desktops (769-1020px)
    T? xxl,  // Large desktops (1021px+)
    required T fallback,
  }) {
    switch (deviceSize) {
      case DeviceSize.xs:
        return xs ?? fallback;
      case DeviceSize.sm:
        return sm ?? fallback;
      case DeviceSize.md:
        return md ?? fallback;
      case DeviceSize.lg:
        return lg ?? fallback;
      case DeviceSize.xl:
        return xl ?? fallback;
      case DeviceSize.xxl:
        return xxl ?? fallback;
    }
  }

  // CONVENIENCE METHODS FOR SPECIFIC UI ELEMENTS

  /// Font size with combined scaling (recommended for text)
  double fontSize(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsiveAverage(value, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Icon size with combined scaling
  double iconSize(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsiveCombined(value, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Padding/margin with combined scaling
  double space(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsiveCombined(value, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Button height with combined scaling
  double buttonHeight(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsiveCombined(value, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Button width with combined scaling
  double buttonWidth(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsiveCombined(value, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  /// Border radius with combined scaling
  double radius(double value, {
    double? xs, double? sm, double? md, double? lg, double? xl, double? xxl,
  }) => responsiveCombined(value, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);

  // Device type helpers for easier understanding
  bool get isSmallPhone => isXs;           // 0-320px
  bool get isMediumPhone => isSm;          // 321-370px
  bool get isLargePhone => isMd;           // 371-425px
  bool get isTabletDevice => isLg;         // 426-768px
  bool get isSmallDesktop => isXl;         // 769-1020px
  bool get isLargeDesktop => isXxl;        // 1021px+

  // Phone/tablet/desktop ranges
  bool get isPhoneSize => screenWidth <= 425;      // XS, SM, MD
  bool get isTabletSize => screenWidth > 425 && screenWidth <= 768;  // LG
  bool get isDesktopSize => screenWidth > 768;     // XL, XXL

  // Deprecated aliases (kept for backward compatibility)
  @deprecated
  double scale(double value, {double baseWidth = 375.0}) =>
      responsive(value, baseWidth: baseWidth, mode: ResponsiveMode.widthOnly);

  @deprecated
  double scaleH(double value, {double baseHeight = 812.0}) =>
      responsive(value, baseHeight: baseHeight, mode: ResponsiveMode.heightOnly);

  // Convenience gaps
  SizedBox gapW(double percent) => SizedBox(width: widthPercent(percent));
  SizedBox gapH(double percent) => SizedBox(height: heightPercent(percent));

  // Debug helper to see current breakpoint info
  String get debugBreakpointInfo =>
      'Screen: ${screenWidth.toInt()}x${screenHeight.toInt()}, '
      'Breakpoint: ${deviceSize.name.toUpperCase()}, '
      'Base: ${_baseWidth.toInt()}x${_baseHeight.toInt()}, '
      'Scales: W=${_widthScale.toStringAsFixed(2)}, H=${_heightScale.toStringAsFixed(2)}, '
      'Combined=${_combinedScale.toStringAsFixed(2)}';
}

/// Responsive scaling modes
enum ResponsiveMode {
  widthOnly,   // Scale based on width only
  heightOnly,  // Scale based on height only  
  combined,    // Use smaller of width/height scale (prevents overflow)
  average,     // Use average of width/height scale (balanced)
}