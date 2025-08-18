import 'package:flutter/material.dart';

import '../../main.dart';

class Dimens{
  static double get width => MediaQuery.of(navigatorKey.currentContext!).size.width;
  static double get height => MediaQuery.of(navigatorKey.currentContext!).size.height;

}