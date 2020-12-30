import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import './myRequest.dart';

class ErrorInfo {
  ErrorInfo({
    ///弹出的提示语
    @required msg,

    ///报错的信息
    @required errInfo,

    ///上下文
    @required BuildContext context,
  }) {
    // 弹窗提示
    this.showToast(msg);

    // 发送错误信息给后台
    this.sendError(errInfo, context);
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // 将错误信息发给后台
  sendError(errInfo, context) async {
    await myRequest(
      context: context,
      path: MyApi.error,
      data: {
        "errInfo": "$errInfo",
        "user_id": true,
      },
    );
  }
}
