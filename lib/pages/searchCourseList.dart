// 课程列表

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';

class SearchCourseList extends StatefulWidget {
  final arguments;
  SearchCourseList({Key key, this.arguments}) : super(key: key);

  @override
  _SearchCourseListState createState() => _SearchCourseListState();
}

class _SearchCourseListState extends State<SearchCourseList> with MyScreenUtil {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  Map _arguments;
  Map courseListData = {
    "page": 1,
    "psize": 20,
    "total": 0,
    "data": [],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _arguments = {
      "searchValue": widget.arguments['searchValue'],
    };

    // 倒计时
    timer = Timer(Duration(seconds: 5), () {
      setState(() {
        _currentMyWidget = 1;
      });
    });

    // 搜索课程
    searchCourseData();
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
        title: Text("课程列表"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return searchCourseData(page: 1);
        },
        child: Container(
          color: Colors.white,
          child: courseListData['data'].length == 0
              ? myWidget[_currentMyWidget]
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    List data = courseListData['data'];
                    int total = courseListData['total'];
                    var item = data[index];

                    // 判断是否需要请求数据
                    if (index == data.length - 1) {
                      // 判断后台是否还是有数据
                      if (data.length < total) {
                        print('请求数据, ${data.length} : $total');

                        // 请求数据
                        int page = ++courseListData['page'];
                        searchCourseData(page: page);

                        return MyProgress();
                      } else {
                        return MyProgress(status: false);
                      }
                    }

                    return CourseCardItem(
                      onClick: () {
                        print(item);
                      },
                      item: item,
                    );
                  },
                  itemCount: courseListData['data'].length,
                ),
        ),
      ),
    );
  }

  // 搜索课程
  searchCourseData({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/course/searchCourse",
        data: {
          "search_value": _arguments['searchValue'],
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
          "id": e['course']['id'], //id
          "thumb_url": e['thum_url'], //封面图
          "title": e['name'], //标题
          "status": e['status'], //状态，是否学完
          "view_num": e['view_num'], //学习人数
          "addtime": addtime, //添加时间
        };
      }).toList();

      // 刷新页面
      setState(() {
        if (page == 1) {
          courseListData['data'] = [];
        }
        courseListData['page'] = page;
        courseListData['total'] = total;
        courseListData['data'].addAll(newData);
      });
    } catch (e) {}
  }
}
