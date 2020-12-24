import 'package:flutter/material.dart';

class PanSanLogo extends StatelessWidget {
  const PanSanLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Image.asset("assets/images/login_logo.png"),
    );
  }
}
