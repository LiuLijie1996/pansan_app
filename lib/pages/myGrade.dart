// 我的班级

import 'dart:async';

import 'package:flutter/material.dart';
import '../models/GradeInfoDataType.dart';
import '../components/EmptyBox.dart';
import '../components/MyIcon.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';

class MyGrade extends StatefulWidget {
  MyGrade({Key key}) : super(key: key);

  @override
  _MyGradeState createState() => _MyGradeState();
}

class _MyGradeState extends State<MyGrade> with MyScreenUtil {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  Map myGradeData = {
    "page": 1,
    "total": 0,
    "data": [],
  };

  _MyGradeState() {
    // 倒计时
    timer = Timer(Duration(seconds: 5), () {
      setState(() {
        _currentMyWidget = 1;
      });
    });

    // 请求数据
    getGradeData();
  }

  @override
  void dispose() {
    // 清除定时器
    timer?.cancel();
    timer = null;
    // TODO: implement dispose
    super.dispose();
  }

  // 获取我的班级数据
  getGradeData({page = 1}) async {
    try {
      var result = await myRequest(
        context: context,
        path: MyApi.getUserClass,
        data: {
          "user_id": 1,
        },
      );

      int total = result['total'];
      List data = result['data'];
      List<GradeInfoDataType> newData = data.map((e) {
        return GradeInfoDataType.fromJson({
          "class_id": e['class_id'],
          "name": e['name'],
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          myGradeData['page'] = page;
          myGradeData['total'] = total;
          myGradeData['data'].addAll(newData);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的班级"),
      ),
      body: myGradeData['data'].length == 0
          ? myWidget[_currentMyWidget]
          : ListView.builder(
              itemCount: myGradeData['data'].length,
              itemBuilder: (BuildContext context, int index) {
                GradeInfoDataType item = myGradeData['data'][index];
                double bottom =
                    index == myGradeData['data'].length - 1 ? 10.0 : 0.0;

                return Container(
                  margin: EdgeInsets.only(
                    top: dp(20.0),
                    bottom: bottom,
                    left: dp(20.0),
                    right: dp(20.0),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: dp(10.0),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(dp(20.0)),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(
                            top: dp(30.0),
                            bottom: dp(30.0),
                            left: dp(20.0),
                            right: dp(20.0),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                width: dp(1.0),
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                          child: Text("${item.name}"),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/coursePlan',
                              arguments: item,
                            );
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                              top: dp(30.0),
                              bottom: dp(30.0),
                              left: dp(20.0),
                              right: dp(20.0),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  width: dp(1.0),
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      myIcon['course_plan'],
                                      size: dp(40.0),
                                    ),
                                    SizedBox(
                                      width: dp(10.0),
                                    ),
                                    Text("课程计划"),
                                  ],
                                ),
                                Icon(
                                  myIcon['arrows_right'],
                                  size: dp(24.0),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/checkingInRecord',
                              arguments: item,
                            );
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(
                              top: dp(30.0),
                              bottom: dp(30.0),
                              left: dp(20.0),
                              right: dp(20.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      myIcon['record'],
                                      size: dp(40.0),
                                    ),
                                    SizedBox(
                                      width: dp(10.0),
                                    ),
                                    Text("考勤记录"),
                                  ],
                                ),
                                Icon(
                                  myIcon['arrows_right'],
                                  size: dp(24.0),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
