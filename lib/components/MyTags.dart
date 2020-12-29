import 'package:flutter/material.dart';
import '../mixins/withScreenUtil.dart';

class MyTags extends StatelessWidget with MyScreenUtil {
  final double width;
  final double height;
  final Color bgColor;
  final Color textColor;
  final BorderRadius radius;
  final String title;
  const MyTags({
    Key key,
    this.width = 120.0,
    this.height = 40.0,
    this.bgColor = Colors.grey,
    this.textColor = Colors.white,
    @required this.radius,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dp(width),
      height: dp(height),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
      ),
      child: Text(
        "$title",
        style: TextStyle(color: textColor, fontSize: dp(28.0)),
      ),
    );
  }
}
