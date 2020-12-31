// 咨询详情

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';

class Arguments {
  int id;
  int pid;
  int addtime;
  String title;
  String content;

  Arguments.formJson(Map json) {
    this.id = json['id'];
    this.pid = json['pid'];
    this.title = json['title'];
    this.addtime = json['addtime'];
    this.content = json['content'];
  }
}

// 时间线上的每一项回复的数据类型
class ReplyItem {
  int id;
  int pid;
  int addtime;
  String content;

  ReplyItem.formJson(Map json) {
    this.id = json['id'];
    this.pid = json['pid'];
    this.addtime = json['addtime'];
    this.content = json['content'];
  }
}

class AdvisoryDetail extends StatefulWidget {
  final Map arguments;
  AdvisoryDetail({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  _AdvisoryDetailState createState() => _AdvisoryDetailState();
}

class _AdvisoryDetailState extends State<AdvisoryDetail> with MyScreenUtil {
  Arguments arguments;
  List<ReplyItem> replyList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.arguments = Arguments.formJson(widget.arguments);
    // 获取咨询详情
    getUserServiceReply();
  }

  // 获取咨询详情
  getUserServiceReply() async {
    try {
      var result = await myRequest(
        path: MyApi.getUserServiceReply,
        data: {
          "user_id": true,
          "id": arguments.id,
        },
      );

      List reply = result['data']['reply'];
      replyList = reply.map((e) {
        return ReplyItem.formJson({
          "id": e['id'],
          "pid": e['pid'],
          "content": e['content'],
          "addtime": e['addtime'],
        });
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取咨询详情失败",
        path: MyApi.getUserServiceReply,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 咨询时间
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      arguments.addtime * 1000,
    );
    var addtime = formatDate(
      dateTime,
      [yyyy, '-', mm, '-', dd, ' ', HH, ':', mm],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("信息详情"),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // 基本信息
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                left: dp(20.0),
                right: dp(20.0),
                top: dp(20.0),
              ),
              padding: EdgeInsets.all(dp(20.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "基本信息",
                    style: TextStyle(
                      fontSize: dp(36.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: dp(20.0)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(dp(20.0)),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey[200],
                        ),
                        left: BorderSide(
                          color: Colors.grey[200],
                        ),
                        right: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: dp(36.0),
                        ),
                        children: <InlineSpan>[
                          TextSpan(text: '咨询标题：'),
                          TextSpan(text: '${arguments.title}'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(dp(20.0)),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey[200],
                        ),
                        left: BorderSide(
                          color: Colors.grey[200],
                        ),
                        right: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: dp(36.0),
                        ),
                        children: <InlineSpan>[
                          TextSpan(text: '咨询内容：'),
                          TextSpan(text: '${arguments.content}'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(dp(20.0)),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[200],
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: dp(36.0),
                        ),
                        children: <InlineSpan>[
                          TextSpan(text: '咨询时间：'),
                          TextSpan(text: '$addtime'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 时间线
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                left: dp(20.0),
                right: dp(20.0),
                bottom: dp(20.0),
              ),
              padding: EdgeInsets.all(dp(20.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "处理信息",
                    style: TextStyle(
                      fontSize: dp(36.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: dp(20.0)),

                  // 时间线
                  ...replyList.map((e) {
                    // 回复时间
                    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      e.addtime * 1000,
                    );
                    var addtime = formatDate(
                      dateTime,
                      [yyyy, '-', mm, '-', dd],
                    );
                    return TimelineWidget(
                      time: "$addtime",
                      content: "${e.content}",
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 时间线组件
class TimelineWidget extends StatelessWidget with MyScreenUtil {
  final String time; //处理时间
  final String content; //处理意见
  const TimelineWidget({Key key, @required this.time, @required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        // 线
        Positioned(
          left: dp(20.0),
          top: dp(10.0),
          bottom: 0,
          child: VerticalDivider(width: 1),
        ),

        // 列表
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: dp(30.0)),
          child: Column(
            children: [
              Row(
                children: [
                  // 圆点
                  CircleAvatar(radius: dp(20.0)),
                  // 时间
                  Container(
                    margin: EdgeInsets.only(left: dp(20.0)),
                    child: Text(
                      "处理时间：$time",
                      style: TextStyle(
                        fontSize: dp(36.0),
                      ),
                    ),
                  ),
                ],
              ),

              // 内容
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: dp(60.0),
                  top: dp(20.0),
                ),
                padding: EdgeInsets.all(dp(20.0)),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(
                    color: Colors.blue[200],
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: dp(36.0),
                      color: Colors.black,
                    ),
                    children: <InlineSpan>[
                      TextSpan(text: '处理意见：'),
                      TextSpan(
                        text: '$content',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
