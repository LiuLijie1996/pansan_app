import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/utils/myRequest.dart';

// 考试页面
class Exam extends StatelessWidget {
  const Exam({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("职工素质提升平台"),
        centerTitle: true,
      ),
      // backgroundColor: Colors.grey[300],
      body: ExamPage(),
    );
  }
}

class ExamPage extends StatefulWidget {
  ExamPage({Key key}) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List myExamNavList = new List(); //我要考试导航列表
  List myExerciseNavList = new List(); //我要练习导航列表

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取导航
    getExamNav();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0, //阴影范围
                    spreadRadius: 0.1, //阴影浓度
                    color: Colors.grey[300], //阴影颜色
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "我要考试",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "是时候展示真正的实力了",
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                          width: 70.0,
                          child: Image.asset("assets/images/exam_head.png"),
                        ),
                      ],
                    ),
                  ),
                  // 我要考试列表
                  Column(
                    children: myExamNavList.length != null
                        ? myExamNavList.map((e) {
                            bool b =
                                e == myExamNavList[myExamNavList.length - 1];
                            return Container(
                              decoration: BoxDecoration(
                                border: b != true
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200],
                                          width: 0.5,
                                        ),
                                      )
                                    : null,
                              ),
                              child: NavItem(
                                item: e,
                                onClick: (Map item) {
                                  print(item);
                                },
                              ),
                            );
                          }).toList()
                        : null,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0, //阴影范围
                    spreadRadius: 0.1, //阴影浓度
                    color: Colors.grey[300], //阴影颜色
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "我要练习",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "多种练习，轻松掌握",
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                          width: 70.0,
                          child: Image.asset("assets/images/test_head.png"),
                        ),
                      ],
                    ),
                  ),
                  // 我要练习列表
                  Column(
                    children: myExerciseNavList.length != null
                        ? myExerciseNavList.map((e) {
                            bool b = e ==
                                myExerciseNavList[myExerciseNavList.length - 1];
                            return Container(
                              decoration: BoxDecoration(
                                border: b != true
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200],
                                          width: 0.5,
                                        ),
                                      )
                                    : null,
                              ),
                              child: NavItem(
                                item: e,
                                onClick: (Map item) {
                                  print(item);
                                },
                              ),
                            );
                          }).toList()
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取导航
  getExamNav() async {
    try {
      var result = await myRequest(path: "/api/nav/nav-all");
      // 获取我要考试列表
      List myExam = result["data"]["exam"]["myExam"];
      // 获取我要练习列表
      List myExercise = result["data"]["exam"]["myExercise"];

      // 图标
      List icons = [
        "assets/images/test_common.png",
        "assets/images/exam_official.png",
        "assets/images/test_level.png",
        "assets/images/exam_official.png",
        "assets/images/test_spe.png",
        "assets/images/exam_official.png",
      ];

      // 遍历我要考试列表
      List exams = myExam.map((e) {
        int _random = Random().nextInt(5 - 0);
        return {
          "id": e['id'],
          "name": e['name'],
          "icons": icons[_random],
        };
      }).toList();

      // 遍历我要答题列表
      List exercises = myExercise.map((e) {
        int _random = Random().nextInt(5 - 0);
        return {
          "id": e['id'],
          "name": e['name'],
          "icons": icons[_random],
        };
      }).toList();

      setState(() {
        myExamNavList = exams;
        myExerciseNavList = exercises;
      });
    } catch (e) {
      print(e);
    }
  }
}

typedef MyFunc = Function(Map item);

// 考试导航列表
class NavItem extends StatelessWidget {
  final item;
  final MyFunc onClick;
  const NavItem({Key key, @required this.item, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick(item);
        }
      },
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          padding: EdgeInsets.all(5.0),
          child: Image.asset(
            "${item['icons']}",
          ),
        ),
        trailing: Icon(
          myIcon['arrows_right'],
          size: 20.0,
        ),
        title: Text(
          "${item['name']}",
          style: TextStyle(
            fontSize: 18.0,
            // fontWeight: FontWeight.w600,
            color: Color(int.parse("333333", radix: 16) | 0xff000000),
          ),
        ),
      ),
    );
  }
}
