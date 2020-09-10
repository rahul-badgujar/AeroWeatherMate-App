import 'package:air_quality_app/resources/constants.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildTimeStampWidget(String timeStamp) {
  return Container(
    margin: EdgeInsets.only(top: 8),
    child: Text(
      "Last Updated : " + updateStatusFromTimeStamp(timeStamp),
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}

Widget buildDataValueDetailWidget(String data, dynamic value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        data + " : ",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      Text(
        "$value",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget buildTitleDataWidget(int data, String unit) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${data}",
            style: TextStyle(
                color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold),
          ),
          Text(
            unit,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );
}

Widget buildShortDetailWidget(String heading, String iconPath) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "${heading}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                iconPath,
                color: Colors.white,
                width: 56,
                height: 56,
              ),
            ),
          ],
        ),
      ),
      decoration: AppDecorations.blurRoundBox(),
    ),
  );
}
