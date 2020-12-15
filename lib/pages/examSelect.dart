// 考试列表选择
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';

class ExamSelect extends StatefulWidget {
  final Map arguments;
  ExamSelect({Key key, this.arguments}) : super(key: key);

  @override
  _ExamSelectState createState() => _ExamSelectState();
}

class _ExamSelectState extends State<ExamSelect> with MyScreenUtil {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  Map examData = {
    "page": 1,
    "psize": 20,
    "total": 0,
    "data": [],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 倒计时
    timer = Timer(Duration(seconds: 5), () {
      setState(() {
        _currentMyWidget = 1;
      });
    });

    // 获取数据
    getExamData();
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
    print(widget.arguments);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.arguments['name']}"),
        centerTitle: true,
      ),
      body: Container(
        // padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: RefreshIndicator(
          onRefresh: () {
            return getExamData(page: 1);
          },
          child: examData['data'].length == 0
              ? myWidget[_currentMyWidget]
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    double bottom =
                        examData['data'].length - 1 == index ? dp(30.0) : 0.0;
                    Map item = examData['data'][index];
                    // 考试状态
                    String examStatus = '';
                    switch (item['status']) {
                      case 0:
                        examStatus = '未开始';
                        break;
                      case 1:
                        examStatus = '进行中';
                        break;
                      case 2:
                        examStatus = '已结束';
                        break;
                    }

                    return Container(
                      margin: EdgeInsets.only(
                        top: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                        bottom: bottom,
                      ),
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(dp(20.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: dp(20.0),
                            offset: Offset(dp(10.0), dp(10.0)),
                          ),
                          BoxShadow(
                            color: Colors.blue[50],
                            blurRadius: dp(20.0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 标题
                          Container(
                            padding: EdgeInsets.only(
                                top: dp(20.0), bottom: dp(20.0)),
                            child: Text(
                              "${item['name']}",
                              style: TextStyle(
                                fontSize: dp(36.0),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          // 时间
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: dp(20.0)),
                                child: Column(
                                  children: [
                                    Text(
                                      "开始",
                                      style: TextStyle(
                                        fontSize: dp(32.0),
                                      ),
                                    ),
                                    SizedBox(height: dp(20.0)),
                                    Text(
                                      "${item['start_time']}",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Image.asset(
                                  "assets/images/jiantou.png",
                                  width: dp(100.0),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: dp(20.0)),
                                child: Column(
                                  children: [
                                    Text(
                                      "结束",
                                      style: TextStyle(
                                        fontSize: dp(32.0),
                                      ),
                                    ),
                                    SizedBox(height: dp(20.0)),
                                    Text(
                                      "${item['end_time']}",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // 分割线
                          SizedBox(
                            child: Divider(),
                          ),

                          // 考试状态
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("$examStatus"),
                              SizedBox(),
                              SizedBox(),
                              RaisedButton(
                                color:
                                    item['is_test'] ? Colors.blue : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(dp(40.0)),
                                ),
                                onPressed: () async {
                                  // 判断是否可以进入考试
                                  if (item['is_test'] == true) {
                                    // 进入考试
                                    Navigator.pushNamed(
                                      context,
                                      "/examSiteInfo",
                                      arguments: {
                                        "test_id": item['id'],
                                      },
                                    );
                                  } else {
                                    String text =
                                        item['status'] == 0 ? '考试未开始' : '考试已结束';

                                    if (item['status'] != 1) {
                                      _showDialog(text);
                                    } else {
                                      _showDialog('不能重复参加考试');
                                    }

                                    Future.delayed(
                                      Duration(milliseconds: 2000),
                                    ).then((value) {
                                      print("关闭弹窗");
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Text(
                                  "开始考试",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(),
                        ],
                      ),
                    );
                  },
                  itemCount: examData['data'].length,
                ),
        ),
      ),
    );
  }

  // 获取数据
  getExamData({page = 1}) async {
    try {
      var result = await myRequest(path: "/api/test/examSelect", data: {
        "id": widget.arguments['id'],
      });

      int total = result['total'] ?? 0;
      List data = result['data'];
      List newData = data.map((e) {
        //开始时间
        DateTime start_time = DateTime.fromMillisecondsSinceEpoch(
          e['start_time'] * 1000,
        );

        //格式化开始时间
        String _start_time = formatDate(
          start_time,
          [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
        );

        //结束时间
        DateTime end_time = DateTime.fromMillisecondsSinceEpoch(
          e['end_time'] * 1000,
        );

        //格式化结束时间
        String _end_time = formatDate(
          end_time,
          [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
        );

        return {
          "id": e["id"], //考试的id
          "type": e["type"], //考试类型
          "name": e["name"], //考试的标题
          "start_time": _start_time, //开始时间
          "end_time": _end_time, //结束时间
          "status": e["status"], //考试状态  0未开始 1进行中 2已结束
          "is_test": e["is_test"], // 当前用户是否可以进入考试
        };
      }).toList();

      if (this.mounted) {
        setState(() {
          if (page == 1) {
            examData['data'] = [];
          }
          examData['page'] = page;
          examData['total'] = total;
          examData['data'].addAll(newData);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // 设置弹窗
  Future _showDialog(String text) {
    Future<bool> _onWillPop() => new Future.value(false);
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) {
        // WillPopScope  可以用来屏蔽返回按键
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(
                left: dp(20.0),
                right: dp(20.0),
                top: dp(20.0),
                bottom: dp(20.0),
              ),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(dp(10.0)),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dp(32.0),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
