import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// 查看文件
Function showFile = ({
  @required context,
  @required String link,
  @required String title,
}) {
  //文件预览api
  const dcsApi = "http://dcsapi.com/?k=54845425608084684823354&url=";
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return WebviewScaffold(
          url: "$dcsApi$link",
          appBar: AppBar(
            title: Text("$title"),
            centerTitle: true,
          ),
        );
      },
    ),
  );
};

// 下载文件
Function downloadFile = ({@required String link}) {
  print(link);
};
