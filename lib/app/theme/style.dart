import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:objectbox_with_chat/app/theme/colors_value.dart';

import 'dimens.dart';

abstract class Styles {
  static TextStyle semiBoldBlack16 = TextStyle(
    color: Colors.black,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.w600,
  );


  static TextStyle boldRed28 = TextStyle(
    color: ColorsValue.lightRedColor,
    fontSize: Dimens.twentyEight,
    fontWeight: FontWeight.w900,
    fontFamily: 'Circular Air Pro',
    letterSpacing:Dimens.zero,
  );

  static TextStyle BoldGrey16 = TextStyle(
    color: ColorsValue.mediumGreyColor,
    fontSize: Dimens.sixTeen,
    fontWeight: FontWeight.w900,
    fontFamily: 'Circular Air Pro',
    letterSpacing:Dimens.zero,
  );


  static TextStyle lightGrey10 = TextStyle(
    color: ColorsValue.lightGreyColor,
    fontSize: Dimens.ten,
    fontWeight: FontWeight.normal,
    fontFamily: 'Circular Air Pro',
    letterSpacing:Dimens.zero,
  );


  static TextStyle white8 = TextStyle(
    color: ColorsValue.whiteColor,
    fontSize: Dimens.eight,
    fontWeight: FontWeight.normal,
    fontFamily: 'Circular Air Pro',
    letterSpacing:Dimens.zero,
  );


  static TextStyle mediumGrey12 = TextStyle(
    color: ColorsValue.mediumGreyColor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
    fontFamily: 'Circular Air Pro',
    letterSpacing:Dimens.zero,
  );

  static TextStyle lightGrey12 = TextStyle(
    color: ColorsValue.lightGreyColor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.normal,
    fontFamily: 'Circular Air Pro',
    letterSpacing:Dimens.zero,
  );


  static TextStyle mediumGrey14 = TextStyle(
    color: ColorsValue.mediumGreyColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.normal,
    fontFamily: 'Circular Air Pro',
    letterSpacing:Dimens.zero,
  );




  // static BoxDecoration defaultCalendarCell = BoxDecoration(
  //   color: ColorsValue.backgroundColor,
  //   boxShadow: kElevationToShadow[1],
  //   borderRadius: BorderRadius.circular(Dimens.five),
  // );


  // static ButtonThemeData buttonThemeData = ButtonThemeData(
  //     buttonColor: ColorsValue.primaryColor,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(
  //         Dimens.fifty,
  //       ),
  //     ));


  // static ButtonStyle greenCircleButtonStyle = ElevatedButton.styleFrom(
  //   shape: const CircleBorder(),
  //   fixedSize: Size(Dimens.sixty, Dimens.sixty),
  //   primary: ColorsValue.darkGreenColor,
  // );


  static var outlineBorderRadius50 = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.fifty,
      ),
    ),
    borderSide: BorderSide.none,
  );



  // static var elevatedButtonTheme = ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //     textStyle: MaterialStateProperty.all(
  //       boldWhite16,
  //     ),
  //     padding: MaterialStateProperty.all(
  //       Dimens.edgeInsets15,
  //     ),
  //     shape: MaterialStateProperty.all(
  //       RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(
  //           Dimens.five,
  //         ),
  //       ),
  //     ),
  //     backgroundColor: MaterialStateProperty.resolveWith<Color>(
  //           (Set<MaterialState> states) => states.contains(MaterialState.disabled)
  //           ? ColorsValue.lightGreyColor
  //           : ColorsValue.primaryColor,
  //     ),
  //   ),
  // );
}