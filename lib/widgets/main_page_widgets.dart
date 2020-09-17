import 'package:air_quality_app/resources/constants.dart' as constants;
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// to build TimeStamp Widget
Widget buildTimeStampWidget(BuildContext context, String timeStamp) {
  return Container(
    child: Text(
      "Last Updated : " + constants.updateStatusFromTimeStamp(timeStamp),
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.white70,
          ),
    ),
  );
}

// build Data Value Pair for Info
Widget buildDataValueDetailWidget(
    BuildContext context, String data, dynamic value, String unit) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        data + " : ",
        style: Theme.of(context).textTheme.subtitle2,
      ),
      Text(
        "$value $unit",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    ],
  );
}

// build Title Data Widget for Full Details Widget
Widget buildTitleDataWidget(
    BuildContext context, int data, double dataLimit, String unit) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularPercentIndicator(
        radius: constants.Numbers.circularPercentIndicatorRadius,
        animation: true,
        animationDuration:
            constants.Numbers.circularPercentIndicatorAnimationDuration,
        lineWidth: constants.Numbers.circularPercentIndicatorLineWidth,
        percent: data / dataLimit,
        backgroundColor: constants.Colours.circularPercentIndicatorBgColor,
        progressColor: constants.Colours.circularPercentIndicatorProgressColor,
        center: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$data",
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              unit,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    ],
  );
}

// build Short Details Widget
Widget buildShortDetailWidget(
    BuildContext context, String heading, String iconPath) {
  return Expanded(
    child: Container(
      margin: constants.Margins.rectMargin,
      child: Padding(
        padding: constants.Paddings.paddingAll,
        child: Column(
          children: [
            Text(
              "$heading",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: constants.Paddings.paddingAll,
              child: SvgPicture.asset(
                iconPath,
                color: Theme.of(context).iconTheme.color,
                width: constants.Numbers.bigSvgIconDim,
                height: constants.Numbers.bigSvgIconDim,
              ),
            ),
          ],
        ),
      ),
      decoration: AppDecorations.blurRoundBox(),
    ),
  );
}
