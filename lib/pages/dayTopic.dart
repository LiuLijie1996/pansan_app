/*一日一题*/
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/DayTopicDataType.dart';
import '../mixins/withScreenUtil.dart';

class DayTopic extends StatefulWidget {
  @override
  _DayTopicState createState() => _DayTopicState();
}

class _DayTopicState extends State<DayTopic> with MyScreenUtil {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  List<DayTopicDataType> dataList = [];

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
      var result = await myRequest(
        path: MyApi.getTodayUserStudy,
        data: {
          "id": 4374,
        },
      );
      List data = result['data'];

      // 遍历数据
      dataList = data.map((e) {
        // 遍历child成员
        List child = e['child'].map((item) {
          Map newItem = {
            "status": item['status'],
            "name": item['name'],
            "id": item['id'],
            "study_time": item["study_time"],
          };
          return newItem;
        }).toList();

        List<Child> newChild = child.map((item) {
          Map<String, dynamic> newItem = {
            "status": item['status'],
            "name": item['name'],
            "id": item['id'],
            "study_time": item["study_time"],
          };
          return Child.fromJson(newItem);
        }).toList();

        // 返回新数据
        return DayTopicDataType(
          time: int.parse("${e['time']}"),
          child: newChild,
        );
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }
}

// 一日一题成员组件
class DayTopicItem extends StatelessWidget with MyScreenUtil {
  final DayTopicDataType item;

  const DayTopicItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Child> child = item.child;

    //时间
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      item.time * 1000,
    );
    // 时间转换
    String _time = formatDate(
      time,
      [yyyy, '年', mm, '月'],
    );

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
              "$_time",
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
              String status = e.status == 1 ? "已学习" : "未学习";
              Color color = e.status == 1 ? Colors.blue : Colors.grey;

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
                    title: Text("${e.name}"),
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
