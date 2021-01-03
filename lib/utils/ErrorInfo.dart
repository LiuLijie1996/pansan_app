import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import './myRequest.dart';

class ErrorInfo {
  ErrorInfo({
    ///弹出的提示语
    msg,

    ///报错的信息
    @required errInfo,

    ///发生错误的接口
    @required path,
  }) {
    if (msg != null) {
      // 弹窗提示
      this.showToast(msg);
    }

    // 发送错误信息给后台
    this.sendError(errInfo: errInfo, path: path);
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
  sendError({
    ///报错的信息
    @required errInfo,

    ///发生错误的接口
    @required path,
  }) async {
    await myRequest(
      path: MyApi.error,
      data: {
        "errInfo": "$errInfo",
        "user_id": true,
        "path": path,
      },
    );
  }
}
