// 考场信息

import 'package:flutter/material.dart';
import '../mixins/mixins.dart';
import '../models/ExamListDataType.dart';

class ExamSiteInfo extends StatefulWidget {
  final ExamListDataType arguments;
  ExamSiteInfo({Key key, @required this.arguments}) : super(key: key);

  @override
  _ExamSiteInfoState createState() => _ExamSiteInfoState();
}

class _ExamSiteInfoState extends State<ExamSiteInfo> with MyScreenUtil {
  ExamListDataType examSiteInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    examSiteInfo = widget.arguments;
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Color(int.parse('666666', radix: 16) | 0xff000000);
    double fontSize = 16.0;

    // 考试次数
    String test_num =
        examSiteInfo.testNum == 0 ? '无限次' : "${examSiteInfo.testNum}次";

    // 考试类型
    String examType = examSiteInfo.type == 1
        ? '模拟考试'
        : examSiteInfo.type == 2
            ? '正式考试'
            : examSiteInfo.type == 3
                ? '补考'
                : '';

    return Scaffold(
      appBar: AppBar(
        title: Text("考场信息"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: dp(40.0), bottom: dp(40.0)),
                child: Text(
                  "${examSiteInfo.name}",
                  style: TextStyle(
                    fontSize: dp(40.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200],
                      width: dp(1.0),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: dp(40.0),
                  bottom: dp(40.0),
                  left: dp(20.0),
                  right: dp(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "考试次数",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "$test_num",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200],
                      width: dp(1.0),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: dp(40.0),
                  bottom: dp(40.0),
                  left: dp(20.0),
                  right: dp(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "考试限时",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "${examSiteInfo.duration == null ? '' : (examSiteInfo.duration / 60).ceil()}分钟",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200],
                      width: dp(1.0),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: dp(40.0),
                  bottom: dp(40.0),
                  left: dp(20.0),
                  right: dp(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "及格分数",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "${examSiteInfo.passingMark}分",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200],
                      width: dp(1.0),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: dp(40.0),
                  bottom: dp(40.0),
                  left: dp(20.0),
                  right: dp(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "考试类型",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "$examType",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200],
                      width: dp(1.0),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: dp(40.0),
                  bottom: dp(40.0),
                  left: dp(20.0),
                  right: dp(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "考试地址",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "${examSiteInfo.address}",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: dp(40.0),
                  bottom: dp(40.0),
                  left: dp(20.0),
                  right: dp(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "考试规则",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    Container(
                      width: dp(400.0),
                      child: Text(
                        "本场考试只能参加$test_num，只能在指定考场参加本次考试！${examSiteInfo.cutScreenType == 1 ? '切屏次数不得大于' + examSiteInfo.cutScreenNum.toString() + '次，离开页面不得超过' + examSiteInfo.cutScreenTime.toString() + '秒' : ''}",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: dp(90.0),
                padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (examSiteInfo.id != null) {
                      // 进入考试
                      Navigator.pushNamed(
                        context,
                        "/examDetails",
                        arguments: {"examSiteInfo": examSiteInfo},
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(dp(10.0)),
                  ),
                  child: Text(
                    "进入考试",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dp(32.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
