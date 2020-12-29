import 'package:flutter/material.dart';
import '../mixins/withScreenUtil.dart';

class EmptyBox extends StatelessWidget with MyScreenUtil {
  const EmptyBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: dp(240.0),
        child: Column(
          children: [
            Image.asset(
              "assets/images/no_data.png",
              width: dp(200.0),
            ),
            Text(
              "空空如也...",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
