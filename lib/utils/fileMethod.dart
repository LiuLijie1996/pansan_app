import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ShowFileArgument {
  ///上下文
  final BuildContext context;

  ///文件地址
  final String link;

  ///网页标题
  final String title;

  ShowFileArgument({
    @required this.context,
    @required this.link,
    @required this.title,
  });
}

// 文件预览
class FilePreview {
  ///上下文
  final BuildContext context;

  ///文件地址
  final String link;

  ///网页标题
  final String title;

  FilePreview({
    @required this.context,
    @required this.link,
    @required this.title,
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
  }
}

// 下载文件
Function downloadFile = ({@required String link}) {
  print(link);
};
