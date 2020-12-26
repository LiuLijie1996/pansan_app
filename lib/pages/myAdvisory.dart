// 我的咨询

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';

class MyAdvisory extends StatefulWidget {
  MyAdvisory({Key key}) : super(key: key);

  @override
  _MyAdvisoryState createState() => _MyAdvisoryState();
}

class _MyAdvisoryState extends State<MyAdvisory> with MyScreenUtil {
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
          Navigator.pushNamed(context, "/addAdvisory");
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
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: myAdvData['data'].length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    var item;
                    String addtime;

                    try {
                      item = myAdvData['data'][index];

                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                        item['addtime'] * 1000,
                      );
                      // 时间转换
                      addtime = formatDate(
                        dateTime,
                        [yyyy, '-', mm, '-', dd],
                      );
                    } catch (e) {
                      // 如果报错了说明要请求数据了

                      // 判断后台有没有数据了
                      if (index == myAdvData['total']) {
                        // 没有数据了
                        return MyProgress(
                          status: false,
                          padding: EdgeInsets.only(top: 0.0, bottom: dp(20.0)),
                        );
                      } else {
                        // 继续请求数据

                        getAdvisoryData(page: ++myAdvData['page']);

                        return MyProgress(
                          padding: EdgeInsets.only(top: 0.0, bottom: dp(20.0)),
                        );
                      }
                    }

                    return Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/advisoryDetail',
                            arguments: item,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item['title']}"),
                            Text("$addtime"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  // 请求数据
  getAdvisoryData({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/user/getUserServiceList",
        data: {
          "user_id": true,
          "pid": 1,
          "page": page,
          "psize": 20,
        },
      );

      int total = result['total'];
      List data = result['data'];
      List newData = data.map((e) {
        return {
          "id": e['id'],
          "pid": e['pid'],
          "title": e['title'],
          "content": e['content'],
          "addtime": e['addtime'],
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
