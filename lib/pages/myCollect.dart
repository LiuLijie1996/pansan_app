// 我的收藏

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';

class MyCollect extends StatefulWidget {
  MyCollect({Key key}) : super(key: key);

  @override
  _MyCollectState createState() => _MyCollectState();
}

class _MyCollectState extends State<MyCollect>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _controller;

  int _currentIndex = 0;

  List tabView = [
    {
      "title": "试题收藏",
      "page": 1,
      "total": 0,
      "data": [],
    },
    {
      "title": "新闻收藏",
      "page": 1,
      "total": 0,
      "data": [],
    },
  ];

  _MyCollectState() {
    _controller = TabController(length: tabView.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _currentIndex = _controller.index;
      });
      // 请求数据
      if (tabView[_currentIndex]['data'].length == 0) {
        // 请求数据
        if (_currentIndex == 0) {
          // 获取收藏的试题
          getTestData();
        } else {
          // 获取收藏的新闻
          getNewsData();
        }
      }
    });

    // 请求数据
    if (_currentIndex == 0) {
      // 获取收藏的试题
      getTestData();
    } else {
      // 获取收藏的新闻
      getNewsData();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
        centerTitle: true,
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              text: "试题收藏",
            ),
            Tab(
              text: "新闻收藏",
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _controller,
          children: tabView.map((e) {
            List data = e['data'];

            if (_currentIndex == 0) {
              return EmptyBox();
            } else {
              if (data.length == 0) {
                return MyProgress();
              }

              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  Map item = data[index];

                  if (data.length - 1 == index) {
                    // 判断后台是否还有数据
                    if (data.length < tabView[_currentIndex]['total']) {
                      // 请求数据
                      getNewsData(page: ++tabView[_currentIndex]['page']);

                      return MyProgress();
                    } else {
                      return MyProgress(status: false);
                    }
                  }

                  return CardItem(
                    onClick: () {
                      print(item);
                    },
                    item: item,
                  );
                },
                itemCount: data.length,
              );
            }
          }).toList()),
    );
  }

  // 获取收藏的试题
  getTestData({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/user/myCollect/test",
        data: {
          "user_id": "用户id",
          "page": page,
        },
      );

      int total = result['total'];
      List data = result['data'];
      List newData = data.map((e) {
        return {};
      }).toList();

      setState(() {
        tabView[_currentIndex]['data'].addAll(newData);
        tabView[_currentIndex]['total'] = total;
        tabView[_currentIndex]['page'] = page;
      });
    } catch (e) {
      print(e);
    }
  }

  // 获取收藏的新闻
  getNewsData({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/user/myCollect/news",
        data: {
          "user_id": "用户id",
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
          "id": e['id'], //id
          "thumb_url": e['thumb_url'], //封面图
          "type": e['type'], //类型：1图文，2视频
          "title": e['title'], //标题
          "addtime": addtime, //发布时间
          "view_num": e['view_num'], //观看人数
        };
      }).toList();

      setState(() {
        tabView[_currentIndex]['data'].addAll(newData);
        tabView[_currentIndex]['total'] = total;
        tabView[_currentIndex]['page'] = page;
      });
    } catch (e) {
      print(e);
    }
  }
}
