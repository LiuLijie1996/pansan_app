// 课程文件预览
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../models/CourseChapterDataType.dart';
import '../utils/myRequest.dart';
import '../mixins/mixins.dart';
import '../models/CourseDataType.dart';
import '../utils/ErrorInfo.dart';

class FilePreview extends StatefulWidget {
  CourseDataType courseData; //课程数据
  int chapterId; //章节id
  ChapterChildren chapterChildren; //子章节
  FilePreview({
    Key key,
    @required this.chapterChildren,
    @required this.chapterId,
    @required this.courseData,
  }) : super(key: key);

  @override
  _FilePreviewState createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> with MyScreenUtil {
  ChapterChildren chapterChildren;
  CourseDataType courseData;
  final dcsApi = "http://dcsapi.com/?k=54845425608084684823354&url="; //文件预览api
  Timer _timer; //定时器
  int validTime; //有效阅读时间
  int seconds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chapterChildren = widget.chapterChildren;
    validTime = chapterChildren.stuDoc;

    courseData = widget.courseData;

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

  // 阅读完成
  readAccomplish() async {
    try {
      await myRequest(
        path: MyApi.courseProgress,
        data: {
          "course_id": courseData.id, //课程id
          "chapter_id": widget.chapterId, //章节id
          "article_id": chapterChildren.id, //子章节id
          "duration": 0, //播放时间
          "finish": validTime == 0, //是否完成
          "user_id": true,
          "type": chapterChildren.materia.type, //资源类型
        },
      );
    } catch (e) {
      ErrorInfo(
        msg: "发送进度失败",
        errInfo: e,
        path: MyApi.newsUserScore,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "$dcsApi${chapterChildren.materia.link}",
      appBar: AppBar(
        title: Text(
          // validTime == 0
          //     ? '阅读完成'
          //     : "有效阅读时间：${validTime != null ? validTime < 10 ? '0' + validTime.toString() : validTime : ''} 秒",

          chapterChildren.name,
        ),
      ),
    );
  }
}
