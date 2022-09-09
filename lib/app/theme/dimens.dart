import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class Dimens {
  static double sixTeen = 16.sp;
  static double seventeen = 17.sp;
  static double nineteen = 19.sp;
  static double three = 3.sp;
  static double eight = 8.sp;
  static double zero = 0.sp;
  static double thirteen = 13.sp;
  static double eighteen = 18.sp;
  static double thirtySix = 36.sp;
  static double twentyEight = 28.sp;
  static double twentyNine = 29.sp;
  static double twentySeven = 27.sp;
  static double six = 6.sp;
  static double sixty = 60.sp;
  static double twentyTwo = 22.sp;
  static double fifty = 50.sp;
  static double one = 1.sp;
  static double twentyFour = 24.sp;
  static double twentyThree = 23.sp;
  static double thirtyNine = 39.sp;
  static double thirtyEight = 38.sp;
  static double fourtyNine = 49.sp;
  static double twentyFive = 25.sp;
  static double thirty = 30.sp;
  static double eighty = 80.sp;
  static double eightyFive = 85.sp;
  static double pointThree = 0.3.sp;
  static double pointFive = 0.5.sp;
  static double negativePointFive = -05.sp;
  static double negativePointTen = -10.sp;
  static double pointSeven = 0.7.sp;
  static double pointEight = 0.8.sp;
  static double pointNine = 0.9.sp;
  static double onePointOne = 1.1.sp;
  static double pointNineFive = 0.95.sp;
  static double twentySix = 26.sp;
  static double sixtyFour = 64.sp;
  static double sixtyEight = 68.sp;

  static double twenty = 20.sp;
  static double twentyOne = 21.sp;
  static double ten = 10.sp;
  static double five = 5.sp;
  static double fifteen = 15.sp;
  static double four = 4.sp;
  static double two = 2.sp;
  static double fourteen = 14.sp;
  static double eleven = 11.sp;
  static double twelve = 12.sp;
  static double thirtyTwo = 32.sp;
  static double thirtyFive = 35.sp;
  static double seventy = 70.sp;
  static double fourty = 40.sp;
  static double fourtyOne =41.sp;
  static double fourtyFive = 45.sp;
  static double fourtyTwo = 42.sp;

  static double thirtyFour = 34.sp;
  static double seven = 7.sp;
  static double ninetyEight = 98.sp;
  static double ninetyFive = 95.sp;
  static double fiftyFive = 55.sp;
  static double fiftyFour = 54.sp;
  static double hundred = 100.sp;
  static double oneThirtyFive = 135.sp;
  static double oneThirtyNine = 139.sp;

  static double oneHundredFifty = 150.sp;
  static double oneHundredFiftyTwo = 152.sp;
  static double oneHundredFiftyThree = 153.sp;
  static double oneHundredFiftyFour = 154.sp;
  static double oneHundredFiftyFive = 155.sp;
  static double oneHundredSixty = 160.sp;
  static double oneHundredSixtyOne = 161.sp;
  static double oneHundredSixtyFive = 165.sp;
  static double oneHundredSeventy = 170.sp;
  static double oneHundredSeventyFive = 175.sp;
  static double oneHundredFourty = 140.sp;
  static double oneHundredThirty = 130.sp;
  static double oneHundredTwenty = 120.sp;
  static double oneHundredTwentyFive = 125.sp;
  static double oneHundredTen = 110.sp;
  static double seventyEight = 78.sp;
  static double seventySix = 76.sp;

  static double seventyFive = 75.sp;
  static double oneHundredNinty = 190.sp;
  static double oneHundredEighty = 180.sp;

  static double twoHundred = 200.sp;
  static double towTen = 210.sp;
  static double towThirty = 230.sp;
  static double twoFifteen = 215.sp;
  static double twoNinteen = 219.sp;
  static double twoTwenty = 220.sp;
  static double twoTwentyFive = 225.sp;
  static double twoThirytyFive = 235.sp;
  static double twoFourty = 240.sp;
  static double twoFifty = 250.sp;
  static double twoSixtyFive = 265.sp;
  static double twoSixty = 260.sp;

  static double twoNinety = 290.sp;
  static double twoEightyFive = 285.sp;

  static double ninety = 90.sp;
  static double oneSeventyFive = 175.sp;
  static double threeFifteen = 315.sp;
  static double threeTwentyFive = 325.sp;
  static double threeThirtyFive = 335.sp;
  static double threeFourtyFive = 345.sp;
  static double threeSeventyFive = 375.sp;
  static double threeEightyFive = 385.sp;
  static double threeNintyFive = 395.sp;
  static double fourHundred = 400.sp;
  static double fourSevntyFive = 475.sp;
  static double fiveSeventyFive = 575.sp;
  static double sixHundred = 600.sp;
  static double sixHundredNinty = 690.sp;
  static double sevenHundredFifty = 750.sp;
  static double eightHundred = 800.sp;
  static double oneThousand = 1000.sp;
  static double nineHundredNinty = 990.sp;
  static double nineHundredFifty = 950.sp;
  static double oneThousandTwentyFive = 1025.sp;
  static double thirtySevenPointFive = 37.5.sp;
  static double nine = 9.sp;

  /// Get the height with the percent value of the screen height.
  static double percentHeight(double percentValue) => percentValue.sh;

  /// Get the width with the percent value of the screen width.
  static double percentWidth(double percentValue) => percentValue.sw;

  static EdgeInsets getEdgeInsets(
      double left,
      double top,
      double right,
      double bottom,
      ) =>
      EdgeInsets.fromLTRB(
        left,
        top,
        right,
        bottom,
      );

  static const EdgeInsets edgeInsets0 = EdgeInsets.zero;

  static EdgeInsets edgeInsets8_8_8_16 = EdgeInsets.fromLTRB(
    eight,
    eight,
    eight,
    sixTeen,
  );

  static EdgeInsets edgeInsets8 = EdgeInsets.all(
    eight,
  );

  static EdgeInsets edgeInsets2 = EdgeInsets.all(
    two,
  );

  static EdgeInsets edgeInsets1 = EdgeInsets.all(
    one,
  );

  static EdgeInsets edgeInsetsTop10 = EdgeInsets.only(
    top: ten
  );

  static EdgeInsets edgeInsetsTop5 = EdgeInsets.only(
      top: five
  );

  static EdgeInsets edgeInsetsLeft10 = EdgeInsets.only(
      left: ten
  );

  static SizedBox boxHeight1 = SizedBox(
    height: one,
  );

  static SizedBox boxHeight5 = SizedBox(
    height: five,
  );

  static SizedBox boxHeight10 = SizedBox(
    height: ten,
  );

  static SizedBox boxHeight20 = SizedBox(
    height: twenty,
  );

  static SizedBox boxWidth20 = SizedBox(
    width: twenty,
  );

  static SizedBox boxWidth14 = SizedBox(
    width: fourteen,
  );




  static SizedBox box0 = const SizedBox.shrink();
}