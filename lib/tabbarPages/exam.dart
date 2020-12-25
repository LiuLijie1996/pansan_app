import 'dart:math';

import 'package:flutter/material.dart';
import '../components/MyIcon.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/NavDataType.dart';
import '../models/ExerciseDataType.dart';

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

class _ExamPageState extends State<ExamPage> with MyScreenUtil {
  List myExamNavList = new List(); //我要考试导航列表
  List myExerciseNavList = new List(); //我要练习导航列表

  @override
  void initState() {
    // 获取导航
    getExamNav();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(top: dp(20.0), left: dp(20.0), right: dp(20.0)),
        child: Column(
          children: [
            // 我要考试
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(dp(20.0))),
                boxShadow: [
                  BoxShadow(
                    blurRadius: dp(20.0), //阴影范围
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
                    children: myExamNavList.map((e) {
                      bool b = e == myExamNavList[myExamNavList.length - 1];
                      NavDataType item = NavDataType.fromJson(e);
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
                          item: item,
                          onClick: () {
                            Navigator.pushNamed(
                              context,
                              "/examSelect",
                              arguments: item,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // 我要练习
            Container(
              margin: EdgeInsets.only(top: dp(20.0), bottom: dp(20.0)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(dp(20.0))),
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
                      left: dp(40.0),
                      right: dp(40.0),
                      top: dp(20.0),
                      bottom: dp(40.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "我要练习",
                              style: TextStyle(fontSize: dp(36.0)),
                            ),
                            SizedBox(
                              height: dp(20.0),
                            ),
                            Text(
                              "多种练习，轻松掌握",
                              style: TextStyle(
                                  fontSize: dp(24.0), color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                          width: dp(140.0),
                          child: Image.asset("assets/images/test_head.png"),
                        ),
                      ],
                    ),
                  ),

                  // 我要练习列表
                  Column(
                    children: myExerciseNavList.map((e) {
                      bool border =
                          e == myExerciseNavList[myExerciseNavList.length - 1];

                      NavDataType item = NavDataType.fromJson(e);
                      return Container(
                        decoration: BoxDecoration(
                          border: border != true
                              ? Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[200],
                                    width: 0.5,
                                  ),
                                )
                              : null,
                        ),
                        child: NavItem(
                          item: item,
                          onClick: () {
                            if (item.id != null) {
                              Navigator.pushNamed(
                                context,
                                "/exerciseSelect",
                                arguments: item,
                              );
                            } else {
                              // 跳转到专项练习列表选择页
                              Navigator.pushNamed(
                                context,
                                "/exerciseSpecialtySelect",
                                arguments:
                                    ExerciseDataType.fromJson(item.toJson()),
                              );
                            }
                          },
                        ),
                      );
                    }).toList(),
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
      var result1 = await myRequest(path: "/api/exam/getTestItemList");
      var result2 = await myRequest(path: "/api/exam/getPracticeItemList");

      // 获取我要考试列表
      List myExam = result1["data"];
      // 获取我要练习列表
      List myExercise = result2["data"];

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
          "id": int.parse("${e['id']}"),
          "name": e['name'],
          "icon": icons[_random],
        };
      }).toList();

      // 遍历我要答题列表
      List exercises = myExercise.map((e) {
        int _random = Random().nextInt(5 - 0);
        return {
          "id": e['id'],
          "name": e['name'],
          "icon": icons[_random],
        };
      }).toList();

      if (this.mounted) {
        setState(() {
          myExamNavList = exams;
          myExerciseNavList = exercises;
          myExerciseNavList.add({
            "name": "专项练习",
            "icon": icons[Random().nextInt(5 - 0)],
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

// 导航列表
class NavItem extends StatelessWidget with MyScreenUtil {
  final NavDataType item;
  final Function() onClick;
  const NavItem({Key key, @required this.item, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick();
        }
      },
      child: ListTile(
        leading: Container(
          width: dp(100.0),
          height: dp(100.0),
          padding: EdgeInsets.all(dp(10.0)),
          child: Image.asset(
            "${item.icon}",
          ),
        ),
        trailing: Icon(
          myIcon['arrows_right'],
          size: dp(30.0),
        ),
        title: Text(
          "${item.name}",
          style: TextStyle(
            fontSize: dp(32.0),
            color: Color(int.parse("333333", radix: 16) | 0xff000000),
          ),
        ),
      ),
    );
  }
}
