import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 120.0,
        child: Column(
          children: [
            Image.asset(
              "assets/images/no_data.png",
              width: 100,
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
