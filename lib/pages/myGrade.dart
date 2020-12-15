// 我的班级

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的班级"),
      ),
      body: myGradeData['data'].length == 0
          ? myWidget[_currentMyWidget]
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Map item = myGradeData['data'][index];
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
                          child: Text("${item['name']}"),
                        ),
                        InkWell(
                          onTap: () {
                            print(item);
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
                            print(item);
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
              itemCount: myGradeData['data'].length,
            ),
    );
  }

  // 请求数据
  getGradeData({page = 1}) async {
    try {
      var result = await myRequest(path: "/api/user/myGrade");

      int total = result['total'];
      List data = result['data'];
      List newData = data.map((e) {
        return {
          "class_id": e['class_id'],
          "name": e['name'],
        };
      }).toList();

      // 清除定时器
      // timer?.cancel();
      setState(() {
        myGradeData['page'] = page;
        myGradeData['total'] = total;
        myGradeData['data'].addAll(newData);
      });
    } catch (e) {}
  }
}
