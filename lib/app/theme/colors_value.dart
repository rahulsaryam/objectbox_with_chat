import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

abstract class ColorsValue {
  static Color themeOppositeColor() =>
      Get.isDarkMode ? Colors.white : Colors.black;


  static const Color lightBlueColor  = Color(
    lightBlueHex,
  );

  static const Color lightRedColor = Color(
    lightRedHex,
  );

  static const Color mediumGreyColor = Color(
    mediumGreyHex,
  );

  static const Color lightGreyColor = Color(
    lightGreyHex,
  );

  static const Color whiteColor = Color(
    whiteHex,
  );

  static const Color greenColor = Color(
    greenHex,
  );

  static const Color moreLightGreyColor = Color(
      moreLightGreyHex,
  );




  static const int lightBlueHex = 0xffF0F8FF;

  static const int lightRedHex = 0xffF5336F;

  static const int mediumGreyHex = 0xff484848;

  static const int lightGreyHex = 0xffB2B2B2;

  static const int whiteHex = 0xffFFFFFF;

  static const int greenHex = 0xff1ACC28;

  static const int moreLightGreyHex = 0xffF5F6F9;
}