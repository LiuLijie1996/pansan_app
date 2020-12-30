// 我的收藏

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../components/CardItem.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../models/NewsDataType.dart';
import '../utils/ErrorInfo.dart';

class MyCollect extends StatefulWidget {
  MyCollect({Key key}) : super(key: key);

  @override
  _MyCollectState createState() => _MyCollectState();
}

class _MyCollectState extends State<MyCollect>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _tabController;

  int _currentIndex = 0;

  List tabs = ["新闻收藏", "试题收藏"];
  int total = 0;
  int page = 1;
  int psize = 20;
  List data = [];
  bool isInitialize = false; //初始化是否完成

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {});

    // 获取数据
    getNewsCollect();
  }

  // 获取收藏的新闻数据
  getNewsCollect() async {
    try {
      var result = await myRequest(
        path: MyApi.getNewsCollect,
        data: {
          "user_id": true,
        },
      );

      total = result['total'];
      List resultData = result['data'];
      data = resultData.map((e) {
        return NewsDataType.fromJson({
          "id": e['id'],
          "pid": e['pid'],
          "title": e['title'],
          "desc": e['desc'],
          "thumb_url": e['thumb_url'],
          "type": e['type'],
          "materia_id": e['materia_id'],
          "content": e['content'],
          "tuij": e['tuij'],
          "isshow": e['isshow'],
          "istop": e['istop'],
          "is_integral": e['is_integral'],
          "addtime": e['addtime'],
          "integral": e['integral'],
          "iintegral_type": e['iintegral_type'],
          "score": e['score'],
          "status": e['status'],
          "sorts": e['sorts'],
          "view_num": e['view_num'],
          "upvote": e['upvote'],
        });
      }).toList();

      if (this.mounted) {
        isInitialize = true;
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: e,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

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
        title: Text("我的收藏"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          int index = tabs.indexOf(e);
          if (index == 0) {
            if (data.length == 0) {
              return EmptyBox();
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                NewsDataType item = data[index];

                return NewsCardItem(
                  onClick: () {},
                  item: item,
                );
              },
            );
          }

          return Center(
            child: RaisedButton(
              onPressed: () {
                // 跳转到试题收藏页面
                Navigator.pushNamed(context, "/questionsCollect");
              },
              color: Colors.blue,
              child: Text(
                "查看更多",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
