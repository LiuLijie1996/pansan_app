// 我的课程

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/utils/myRequest.dart';

class MyCourse extends StatefulWidget {
  MyCourse({Key key}) : super(key: key);

  @override
  _MyCourseState createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> {
  Map myCourseData = {
    "total": 0,
    "data": [],
    "page": 1,
  };

  @override
  void initState() {
    // 请求数据
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的课程"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        // 下拉刷新的回调
        onRefresh: () {
          return getData(page: 1);
        },
        child: Container(
          color: Colors.white,
          child: myCourseData['data'].length == 0
              ? EmptyBox()
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    List data = myCourseData['data'];
                    int total = myCourseData['total'];
                    var item = data[index];

                    // 判断是否需要请求数据
                    if (index == data.length - 1) {
                      // 判断后台是否还是有数据
                      if (data.length < total) {
                        // 请求数据
                        int page = myCourseData['page'];
                        getData(page: ++page);

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
                  itemCount: myCourseData['data'].length,
                ),
        ),
      ),
    );
  }

  // 请求数据
  getData({
    int page = 1,
  }) async {
    try {
      var result = await myRequest(
        path: "/api/user/myCourse",
        data: {
          "user_id": "用户id",
          "page": page,
        },
      );
      List data = result['data'];
      int total = result['total'];

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
          "id": e['course']['id'], //id
          "thumb_url": e['thum_url'], //封面图
          "title": e['name'], //标题
          "status": e['status'], //状态，是否学完
          "view_num": e['view_num'], //学习人数
          "addtime": addtime, //添加时间
        };
      }).toList();

      setState(() {
        if (page == 1) {
          myCourseData['data'] = []; //清空数据
        }

        myCourseData['data'].addAll(newData);
        myCourseData['page'] = page;
        myCourseData['total'] = total;
      });
    } catch (e) {
      print(e);
    }
  }
}
