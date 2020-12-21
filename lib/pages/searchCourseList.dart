// 课程列表

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';
import 'package:pansan_app/models/CourseDataType.dart';

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
                  itemCount: courseListData['data'].length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    var data = courseListData['data'];
                    int total = courseListData['total'];
                    CourseDataType item;

                    // 判断后台是不是已经没有数据了
                    if (index == total) {
                      return MyProgress(status: false);
                    }

                    try {
                      // 如果报错了说明需要请求数据了
                      item = data[index];
                    } catch (e) {
                      // 请求数据
                      int page = ++courseListData['page'];
                      searchCourseData(page: page);

                      return MyProgress();
                    }

                    return CourseCardItem(
                      item: item,
                      onClick: () {
                        print(item);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  // 搜索课程
  searchCourseData({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/course/courseList",
        data: {
          "value": _arguments['searchValue'],
          "page": page,
          "psize": 20,
          "user_id": 1,
        },
      );

      int total = result['total'];
      List data = result['data'];
      List<CourseDataType> newData = [];
      data.forEach((e) {
        Map<String, dynamic> courseItem = {
          "id": e['id'], //id
          "thumb_url": e['thum_url'], //封面图
          "name": e['name'], //标题
          "study_status": e['status'], //状态，是否学完
          "view_num": e['view_num'], //学习人数
          "addtime": e['addtime'], //添加时间
        };
        newData.add(CourseDataType.fromJson(courseItem));
      });

      // 刷新页面
      if (this.mounted) {
        setState(() {
          if (page == 1) {
            courseListData['data'] = [];
          }
          courseListData['page'] = page;
          courseListData['total'] = total;
          courseListData['data'].addAll(newData);
        });
      }
    } catch (e) {}
  }
}
