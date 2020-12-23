// 文件预览
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../models/CourseChapterDataType.dart';
import '../utils/myRequest.dart';
import '../mixins/withScreenUtil.dart';

class FilePreview extends StatefulWidget {
  ChapterChildren arguments;
  FilePreview({Key key, @required this.arguments}) : super(key: key);

  @override
  _FilePreviewState createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> with MyScreenUtil {
  ChapterChildren arguments;
  final dcsApi = "http://dcsapi.com/?k=54845425608084684823354&url="; //文件预览api
  Timer _timer; //定时器
  int validTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    arguments = widget.arguments;
    validTime = arguments.stuDoc;
    print(validTime);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (validTime != null) {
        if (this.mounted) {
          setState(() {
            --validTime;
          });

          if (validTime == 0) {
            _timer.cancel(); //清除定时器

            // 通知后台阅读完成
            readAccomplish();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); //清除定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文件预览"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(dp(10.0)),
            decoration: BoxDecoration(
              color: Colors.yellow,
            ),
            child: Text(
              validTime == 0
                  ? '阅读完成'
                  : "有效阅读时间：${validTime != null ? validTime < 10 ? '0' + validTime.toString() : validTime : ''} 秒",
              style: TextStyle(fontSize: dp(30.0)),
            ),
          ),

          // 文件预览
          Expanded(
            child: WebviewScaffold(
              url: "$dcsApi${arguments.materia.link}",
            ),
          ),
        ],
      ),
    );
  }

  // 阅读完成
  readAccomplish() async {
    try {
      var result = await myRequest(
        path: "/api/news/newsUserScore",
        data: {
          "id": arguments.id,
          "user_id": 1,
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
