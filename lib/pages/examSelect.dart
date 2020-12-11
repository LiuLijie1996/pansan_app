// 考试列表选择

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:pansan_app/utils/myRequest.dart';

class ExamSelect extends StatefulWidget {
  final Map arguments;
  ExamSelect({Key key, this.arguments}) : super(key: key);

  @override
  _ExamSelectState createState() => _ExamSelectState();
}

class _ExamSelectState extends State<ExamSelect> {
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

    // 获取数据
    getExamData();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.arguments);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.arguments['name']}"),
      ),
      body: Container(
        // padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: RefreshIndicator(
          onRefresh: () {
            return getExamData(page: 1);
          },
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              double bottom = examData['data'].length - 1 == index ? 15.0 : 0.0;
              Map item = examData['data'][index];
              // 考试状态
              String examStatus = item['status'] == 0
                  ? '未开始'
                  : item['status'] == 1
                      ? '进行中'
                      : item['status'] == 2
                          ? '已结束'
                          : '';

              return Container(
                margin: EdgeInsets.only(
                  top: 15.0,
                  left: 10.0,
                  right: 10.0,
                  bottom: bottom,
                ),
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 10.0,
                      offset: Offset(5.0, 5.0),
                    ),
                    BoxShadow(
                      color: Colors.blue[50],
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 标题
                    Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        "${item['name']}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // 时间
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              Text(
                                "开始",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
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
                            width: 50.0,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Column(
                            children: [
                              Text(
                                "结束",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
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
                          color: item['is_test'] ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          onPressed: () {
                            // 判断是否可以进入考试
                            if (item['is_test']) {
                              // 进入考试
                              Navigator.pushNamed(
                                context,
                                "/examSiteInfo",
                                arguments: {
                                  "test_id": item['id'],
                                },
                              );
                            } else {
                              print("不能进入考场");
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

      setState(() {
        if (page == 1) {
          examData['data'] = [];
        }
        examData['page'] = page;
        examData['total'] = total;
        examData['data'].addAll(newData);
      });
    } catch (e) {
      print(e);
    }
  }
}
