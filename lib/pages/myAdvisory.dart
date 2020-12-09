// 我的咨询

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/utils/myRequest.dart';

class MyAdvisory extends StatefulWidget {
  MyAdvisory({Key key}) : super(key: key);

  @override
  _MyAdvisoryState createState() => _MyAdvisoryState();
}

class _MyAdvisoryState extends State<MyAdvisory> {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  Map myAdvData = {
    "page": 1,
    "total": 0,
    "data": [],
  };

  _MyAdvisoryState() {
    // 倒计时
    timer = Timer(Duration(seconds: 5), () {
      setState(() {
        _currentMyWidget = 1;
      });
    });

    // 请求数据
    getAdvisoryData();
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
        title: Text("我的咨询"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("添加咨询");
        },
      ),
      body: RefreshIndicator(
        // 下拉刷新
        onRefresh: () {
          return getAdvisoryData(page: 1);
        },
        child: myAdvData['data'].length == 0
            ? myWidget[_currentMyWidget]
            : Container(
                color: Colors.white,
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    var item = myAdvData['data'][index];

                    // 判断是否需要请求数据
                    if (myAdvData['data'].length - 1 == index) {
                      // 判断后台是否还有数据
                      if (myAdvData['data'].length < myAdvData['total']) {
                        // 请求数据
                        getAdvisoryData(page: ++myAdvData['page']);

                        return MyProgress(
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                        );
                      } else {
                        return MyProgress(
                          status: false,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                        );
                      }
                    }
                    return Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: InkWell(
                        onTap: () {
                          print(item);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item['title']}"),
                            Text("${item['addtime']}"),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: myAdvData['data'].length,
                ),
              ),
      ),
    );
  }

  // 请求数据
  getAdvisoryData({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/staff-serve",
        data: {
          "user_id": "用户id",
          "pid": 1,
          "page": page,
        },
      );

      int total = result['total'];
      List data = result['data'];
      List newData = data.map((e) {
        //时间
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          e['addtime'] * 1000,
        );
        // 时间转换
        String addtime = formatDate(
          dateTime,
          [yyyy, '-', mm, '-', dd],
        );

        return {
          "id": e['id'],
          "pid": e['pid'],
          "title": e['title'],
          "content": e['content'],
          "addtime": addtime,
        };
      }).toList();

      setState(() {
        if (page == 1) {
          // 清空数据
          myAdvData['data'] = [];
        }

        myAdvData['total'] = total;
        myAdvData['page'] = page;
        myAdvData['data'].addAll(newData);
      });
    } catch (e) {
      print(e);
    }
  }
}
