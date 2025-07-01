import 'package:flutter/material.dart';

extension MediaQuary on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isPortrait => orientation == Orientation.portrait;
  
  bool get isLandscape => orientation == Orientation.landscape;

  EdgeInsets get padding => MediaQuery.of(this).padding;

  double get topPadding => MediaQuery.of(this).padding.top;

  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  double get leftPadding  => MediaQuery.of(this).padding.left;

  double get rightPadding => MediaQuery.of(this).padding.right;


  bool get isPhone => screenWidth < 600;

  bool get isTablet => screenWidth >= 600;

  double widthPercent(double percent) => screenWidth * (percent/100);

  double heightPercent(double percent) => screenHeight * (percent/100);

  double responsive(double value) => value * (screenHeight / 375.0);
  
}