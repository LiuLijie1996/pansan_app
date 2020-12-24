import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../utils/myRequest.dart';

class ErrorInfo {
  String errInfo;
  ErrorInfo(errInfo) {
    this.errInfo = errInfo;
    // 弹窗提示
    this.showToast(errInfo);

    // 发送错误信息给后台
    this.sendError();
  }

  showToast(errInfo) {
    Fluttertoast.showToast(
      msg: "$errInfo",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // 将错误信息发给后台
  sendError() async {
    await myRequest(
      path: "/api/error",
      data: {
        "msg": "$errInfo",
        "user_id": true,
      },
    );
  }
}
