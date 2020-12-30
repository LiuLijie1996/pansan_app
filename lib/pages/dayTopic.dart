/*一日一题*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/DayTopicDataType.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/ErrorInfo.dart';

class DayTopic extends StatefulWidget {
  @override
  _DayTopicState createState() => _DayTopicState();
}

class _DayTopicState extends State<DayTopic> with MyScreenUtil {
  List<DayTopicDataType> dataList = [];
  bool isInitialize = false; //初始化是否完成

  @override
  void initState() {
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    //获取一日一题数据
    this.getDayTopic();
  }

  //获取一日一题数据
  getDayTopic() async {
    try {
      var result = await myRequest(
        path: MyApi.getTodayUserStudy,
        data: {
          "user_id": true,
          // "id": 4374,
        },
      );

      List data = result['data'];
      // 遍历数据
      dataList = data.map((e) {
        // 遍历child成员
        List children = e['child'].map((item) {
          return {
            "status": item['status'],
            "name": item['name'],
            "id": item['id'],
            "study_time": item["study_time"],
          };
        }).toList();

        // 返回新数据
        return DayTopicDataType.fromJson({
          "time": e['time'],
          "child": children,
        });
      }).toList();

      if (this.mounted) {
        isInitialize = true;
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取一日一题数据失败",
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialize) {
      return Scaffold(
        body: MyProgress(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("一日一题"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        // 下拉刷新的回调
        onRefresh: () {
          return getDayTopic();
        },
        child: Container(
          child: dataList.length == 0
              ? EmptyBox()
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
}

// 一日一题成员组件
class DayTopicItem extends StatelessWidget with MyScreenUtil {
  final DayTopicDataType item;

  const DayTopicItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TimeChildren> child = item.child;

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
                  // 跳转到详情页
                  Navigator.pushNamed(
                    context,
                    "/dayTopicDetail",
                    arguments: e,
                  );
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
