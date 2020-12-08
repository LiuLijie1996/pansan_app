import 'package:flutter/material.dart';

// 环形进度器
class MyProgress extends StatelessWidget {
  double strokeWidth;
  double size;
  bool status; //true还有数据，显示进度器；false没有数据，显示没有数据
  MyProgress(
      {Key key, this.strokeWidth = 2.0, this.size = 20.0, this.status = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == true) {
      return Center(
        child: UnconstrainedBox(
          child: Container(
            width: size,
            height: size,
            margin: EdgeInsets.only(
              bottom: 10.0,
              top: 10.0,
            ),
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
            ), //环形进度器
          ),
        ),
      );
    } else {
      return Center(
        child: AspectRatio(
          aspectRatio: 16 / 1.5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              "没有更多数据了...",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }
  }
}
