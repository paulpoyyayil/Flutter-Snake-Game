import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  double responsive(double size, {Axis axis = Axis.vertical}) {
    final currentSize =
        axis == Axis.horizontal ? screenSize.width : screenSize.height;
    final designSize = axis == Axis.horizontal ? 375 : 812;

    return size * currentSize / designSize;
  }
}

List<String> snakeIcons = [
  'assets/snake_icon/snake_icon_1.png',
  'assets/snake_icon/snake_icon_2.png',
  'assets/snake_icon/snake_icon_3.png',
  'assets/snake_icon/snake_icon_4.png',
  'assets/snake_icon/snake_icon_5.png',
];

bool hasSound = true;
bool hasVibration = true;
