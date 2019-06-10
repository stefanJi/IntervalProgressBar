import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intervalprogressbar/intervalprogressbar.dart';

Widget buildAProgressBar() {
  return Center(
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [10, 29, 18, 27, 16, 15, 24, 3, 20, 10].map<Widget>((i) {
          return Padding(
              padding: EdgeInsets.only(right: 10),
              child: IntervalProgressBar(
                  direction: IntervalProgressDirection.vertical,
                  max: 30,
                  progress: i,
                  intervalSize: 2,
                  size: Size(12, 200),
                  highlightColor: Colors.red,
                  defaultColor: Colors.grey,
                  intervalColor: Colors.transparent,
                  intervalHighlightColor: Colors.transparent,
                  reverse: true,
                  radius: 0));
        }).toList()),
  );
}
