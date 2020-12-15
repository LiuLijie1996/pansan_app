/*一日一题*/
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';

class DayTopic extends StatefulWidget {
  @override
  _DayTopicState createState() => _DayTopicState();
}

class _DayTopicState extends State<DayTopic> {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  List dataList = [];

  _DayTopicState() {
    // 倒计时
    timer = Timer(Duration(seconds: 5), () {
      setState(() {
        _currentMyWidget = 1;
      });
    });

    //获取数据
    this.getDayTopic();
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
        title: Text("一日一题"),
      ),
      body: RefreshIndicator(
        // 下拉刷新的回调
        onRefresh: () {
          return getDayTopic();
        },
        child: Container(
          child: dataList.length == 0
              ? myWidget[_currentMyWidget]
              : ListView(
                  children: dataList.map((e) {
                    return DayTopicItem(
                      item: e,
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  getDayTopic() async {
    try {
      var result = await myRequest(path: "/api/day-topic");
      List data = result['data'];
      List newData = data.map((e) {
        //所属年月
        DateTime time = DateTime.fromMillisecondsSinceEpoch(
          e['time'] * 1000,
        );

        //格式化所属年月
        String _time = formatDate(
          time,
          [yyyy, '年', mm, '月'],
        );

        List child = e['child'];
        List newChild = child.map((item) {
          //所属年月
          DateTime study_time = DateTime.fromMillisecondsSinceEpoch(
            item['study_time'] * 1000,
          );

          //格式化所属年月
          String _study_time = formatDate(
            study_time,
            [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
          );

          return {
            "id": item["id"], //id
            "name": item["name"], //标题
            "status": item["status"], //1已查看，2未查看
            "study_time": _study_time, //具体时间
          };
        }).toList();

        return {
          "time": _time, //所属年月
          "child": newChild, //题目列表
        };
      }).toList();

      setState(() {
        dataList = newData;
      });
    } catch (e) {
      print(e);
    }
  }
}

// 一日一题成员组件
class DayTopicItem extends StatelessWidget with MyScreenUtil {
  final Map item;

  const DayTopicItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List child = item['child'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              width: dp(6.0),
              height: dp(30.0),
              margin: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
              color: Colors.blue,
            ),
            Text(
              "${item['time']}",
              style: TextStyle(
                fontSize: dp(40.0),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
          child: Column(
            children: child.map((e) {
              String status = e['status'] == 1 ? "已学习" : "未学习";
              Color color = e['status'] == 1 ? Colors.blue : Colors.grey;

              return InkWell(
                onTap: () {
                  print(e);
                },
                child: Container(
                  margin: EdgeInsets.only(top: dp(20.0)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(dp(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: dp(10.0),
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text("${e['name']}"),
                    subtitle: Text(
                      status,
                      style: TextStyle(color: color),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
