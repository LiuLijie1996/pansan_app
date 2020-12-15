// 考试记录

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';

class TestRecords extends StatefulWidget {
  TestRecords({Key key}) : super(key: key);

  @override
  _TestRecordsState createState() => _TestRecordsState();
}

class _TestRecordsState extends State<TestRecords> with MyScreenUtil {
  Map testRecordsData = {
    "total": 0,
    "page": 1,
    "data": [],
  };

  _TestRecordsState() {
    // 获取考试记录
    getTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("考试记录"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var item = testRecordsData['data'][index];
            return InkWell(
              onTap: () {
                print(item);
              },
              child: ListTile(
                title: Text(
                  "${item['test']['name']}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("${item['update_time']}"),
                trailing: Container(
                  width: dp(180.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item['fraction']} 分",
                        style: TextStyle(fontSize: dp(32.0)),
                      ),
                      Icon(
                        myIcon['arrows_right'],
                        size: dp(30.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: testRecordsData['data'].length,
        ),
      ),
    );
  }

  // 获取考试记录
  getTestData({page = 1}) async {
    try {
      var result = await myRequest(path: "/api/user/testRecords");

      int total = result['total'];
      List data = result['data'];
      List newData = data.map((e) {
        //时间
        DateTime update_time = DateTime.fromMillisecondsSinceEpoch(
          e['update_time'] * 1000,
        );

        // 时间转换
        String _update_time = formatDate(
          update_time,
          [yyyy, '-', mm, '-', dd, " ", HH, ":", mm],
        );

        double fraction = double.parse("${e["fraction"]}");

        return {
          "test": {
            "id": e['test']['id'], //考试的id
            "name": e['test']['name'], //考试的名称
          },
          "update_time": _update_time, //完成考试的时间
          "fraction": fraction, //考试得分
        };
      }).toList();

      setState(() {
        testRecordsData['data'].addAll(newData);
        testRecordsData['page'] = page;
        testRecordsData['total'] = total;
      });
    } catch (e) {
      print(e);
    }
  }
}
