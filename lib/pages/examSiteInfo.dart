// 考场信息

import 'package:flutter/material.dart';
import 'package:pansan_app/utils/myRequest.dart';

class ExamSiteInfo extends StatefulWidget {
  final Map arguments;
  ExamSiteInfo({Key key, this.arguments}) : super(key: key);

  @override
  _ExamSiteInfoState createState() => _ExamSiteInfoState();
}

class _ExamSiteInfoState extends State<ExamSiteInfo> {
  Map examSiteInfo = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    getExamSiteInfo();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Color(int.parse('666666', radix: 16) | 0xff000000);
    double fontSize = 16.0;

    // 考试次数
    String test_num =
        examSiteInfo['test_num'] == 0 ? '无限次' : "${examSiteInfo['test_num']}次";

    // 考试类型
    String examType = examSiteInfo['type'] == 1
        ? '模拟考试'
        : examSiteInfo['type'] == 2
            ? '正式考试'
            : examSiteInfo['type'] == 3
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
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text(
                  "技术部测试11月月考",
                  style: TextStyle(
                    fontSize: 20.0,
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
                      width: 0.5,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
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
                      width: 0.5,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
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
                      "${examSiteInfo['duration']}分钟",
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
                      width: 0.5,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
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
                      "${examSiteInfo['passing_mark']}分",
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
                      width: 0.5,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
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
                      width: 0.5,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
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
                      "${examSiteInfo['address']}",
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
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
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
                      width: 200.0,
                      child: Text(
                        "本场考试只能参加$test_num，只能在指定考场参加本次考试！${examSiteInfo['cut_screen_type'] == 1 ? '切屏次数不得大于' + examSiteInfo['cut_screen_num'].toString() + '次，离开页面不得超过' + examSiteInfo['cut_screen_time'].toString() + '秒' : ''}",
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
                height: 45.0,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    "进入考试",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
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

  // 请求数据
  getExamSiteInfo() async {
    try {
      var result = await myRequest(path: "/api/test/examSiteInfo", data: {
        "test_id": widget.arguments['test_id'],
      });
      Map data = result['data'];
      setState(() {
        examSiteInfo = {
          "id": data['id'], //考试id
          "type": data['type'], //考试类型
          "address": data['address'], //考试地址
          "duration": data['duration'], //考试限时
          "passing_mark": data['passing_mark'], //及格分数
          "test_num": data['test_num'], //考试次数
          "cut_screen_type": data['cut_screen_type'], //是否开启切屏限制  1开启切屏限制
          "cut_screen_num": data['cut_screen_num'], //考试时切屏最大次数
          "cut_screen_time": data['cut_screen_time'], //考试切屏时最大等待时间
        };
      });
    } catch (e) {
      print(e);
    }
  }
}
