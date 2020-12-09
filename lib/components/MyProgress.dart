import 'package:flutter/material.dart';

// 环形进度器
class MyProgress extends StatelessWidget {
  final double strokeWidth;
  final double size;
  final bool status; //true还有数据，显示进度器；false没有数据，显示没有数据
  final EdgeInsets padding;
  MyProgress({
    Key key,
    this.strokeWidth = 2.0,
    this.size = 20.0,
    this.status = true,
    this.padding = const EdgeInsets.only(
      top: 10.0,
      bottom: 10.0,
      left: 0.0,
      right: 0.0,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == true) {
      return Center(
        child: UnconstrainedBox(
          child: Container(
            width: size,
            height: size,
            margin: EdgeInsets.only(
              top: padding.top,
              bottom: padding.bottom,
              left: padding.left,
              right: padding.right,
            ),
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
            ), //环形进度器
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: padding.top,
          bottom: padding.bottom,
          left: padding.left,
          right: padding.right,
        ),
        child: Text(
          "没有更多数据了...",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }
  }
}
