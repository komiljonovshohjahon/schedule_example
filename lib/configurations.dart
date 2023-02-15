import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Configs {
  final MaterialScrollBehavior scrollBehavior = CustomScrollBehavior();
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
