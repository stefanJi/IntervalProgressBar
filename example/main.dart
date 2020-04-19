import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intervalprogressbar/intervalprogressbar.dart';

Widget buildProgressBars() {
  return Center(
      child: Padding(
    padding: const EdgeInsets.only(top: 100),
    child: Column(
      children: <Widget>[
        buildHorizontal(),
        SizedBox(height: 20),
        buildVertical(),
        SizedBox(height: 20),
        buildCircle(),
      ],
    ),
  ));
}

Widget buildHorizontal() => IntervalProgressBar(
    direction: IntervalProgressDirection.horizontal,
    max: 30,
    progress: 10,
    intervalSize: 2,
    size: Size(400, 10),
    highlightColor: Colors.red,
    defaultColor: Colors.grey,
    intervalColor: Colors.transparent,
    intervalHighlightColor: Colors.transparent,
    reverse: true,
    radius: 0);

Widget buildVertical() => Row(
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
    }).toList());

Widget buildCircle() => IntervalProgressBar(
      direction: IntervalProgressDirection.circle,
      max: 30,
      progress: 10,
      intervalSize: 2,
      size: Size(200, 200),
      highlightColor: Colors.red,
      defaultColor: Colors.grey,
      intervalColor: Colors.transparent,
      intervalHighlightColor: Colors.transparent,
      reverse: true,
      radius: 0,
      intervalDegrees: 5,
      strokeWith: 5,
    );

void main() {
  final app = MaterialApp(home: buildProgressBars());
  runApp(app);
}
