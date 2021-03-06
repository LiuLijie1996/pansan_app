// 一日一题

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../components/MyProgress.dart';
import '../mixins/mixins.dart';
import '../models/DayTopicDetailDataType.dart';
import '../models/DayTopicDataType.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';
import '../components/MyIcon.dart';

class DayTopicDetail extends StatefulWidget {
  final TimeChildren arguments;
  DayTopicDetail({Key key, @required this.arguments}) : super(key: key);

  @override
  _DayTopicDetailState createState() => _DayTopicDetailState();
}

class _DayTopicDetailState extends State<DayTopicDetail> with MyScreenUtil {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DayTopicDetailDataType dayTopicDetail;
  int fontSize = 120;
  List fontSizeList = [120, 80, 100, 140, 160, 180, 200];
  List titleList = ["默认字体", '超小字体', '小字体', '中等字体', '大字体', '大号字体', "超大号字体"];

  @override
  void initState() {
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    // 获取一日一题详情
    getDetail();

    // 阅读完成请求
    saveTodayStudy();
  }

  // 获取一日一题详情
  getDetail() async {
    try {
      print("获取一日一题详情: ${widget.arguments.id}");
      var result = await myRequest(
        path: MyApi.getOneTodayStudy,
        data: {
          "id": widget.arguments.id,
        },
      );

      dayTopicDetail = DayTopicDetailDataType.fromJson({
        "id": result['data']['id'],
        "d_id": result['data']['d_id'],
        "name": result['data']['name'],
        "study_time": result['data']['study_time'],
        "addtime": result['data']['addtime'],
        "content": result['data']['content'],
        "analysis": result['data']['analysis'],
        "status": result['data']['status']
      });

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取一日一题详情失败",
        path: MyApi.getOneTodayStudy,
      );
    }
  }

  // 发送阅读完成请求
  saveTodayStudy() async {
    try {
      await myRequest(
        path: MyApi.saveTodayStudy,
        data: {
          "user_id": true,
          "id": widget.arguments.id,
          "study_time": widget.arguments.studyTime,
        },
      );
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "发送阅读进度失败",
        path: MyApi.saveTodayStudy,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dayTopicDetail == null) {
      return Scaffold(
        body: MyProgress(),
      );
    }
    DateTime studyTime = DateTime.fromMillisecondsSinceEpoch(
      widget.arguments.studyTime * 1000,
    );
    String _studyTime = formatDate(
      studyTime,
      [yyyy, '年', mm, '月', dd, "日"],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("一日一题详情"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
            icon: Icon(
              aliIconfont.wenzi,
              color: Colors.white,
            ),
          ),
        ],
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: [
              SizedBox(height: dp(50.0)),
              ...fontSizeList.map((item) {
                int index = fontSizeList.indexOf(item);
                String title = titleList[index];

                return ListTile(
                  leading: Radio(
                    value: item,
                    groupValue: fontSize,
                    onChanged: (value) {
                      setState(() {
                        fontSize = item;
                      });
                    },
                  ),
                  title: Text(
                    "$title",
                    style: TextStyle(
                      fontSize: dp(32.0),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      fontSize = item;
                    });
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          // 标题
          Container(
            padding: EdgeInsets.all(dp(20.0)),
            child: Text(
              "${widget.arguments.name}",
              style: TextStyle(
                fontSize: dp(46.0),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // 时间
          Container(
            padding: EdgeInsets.only(left: dp(20.0)),
            child: Text("$_studyTime"),
          ),

          // 详情内容
          Html(
            data: "<div>${dayTopicDetail.content}</div>",
            style: {
              "div": Style(
                fontSize: FontSize.percent(fontSize),
                lineHeight: dp(3.0),
              ),
            },
          ),

          // 解析
          Html(
            data: "<div>解析：${dayTopicDetail.analysis}</div>",
            style: {
              "div": Style(
                fontSize: FontSize.percent(fontSize),
                lineHeight: dp(3.0),
              ),
            },
          ),
        ],
      ),
    );
  }
}
