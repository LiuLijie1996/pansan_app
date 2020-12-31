// 课程列表

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/CardItem.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/CourseDataType.dart';
import '../utils/ErrorInfo.dart';

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

  Map arguments;
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

    arguments = widget.arguments;

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

  // 搜索课程
  searchCourseData({page = 1}) async {
    try {
      var result = await myRequest(
        path: MyApi.courseList,
        data: {
          "searchValue": arguments['searchValue'],
          "isTags": arguments['isTags'],
          "page": page,
          "psize": 20,
          "user_id": true,
        },
      );

      int total = result['total'];
      List data = result['data'].map((e) {
        List chapter = e['chapter'].map((item) {
          return {
            "id": item['id'],
            "pid": item['pid'],
            "d_id": item['d_id'],
            "name": item['name'],
            "addtime": item['addtime']
          };
        }).toList();

        return CourseDataType.fromJson({
          "id": e['id'],
          "d_id": e['d_id'],
          "pid": e['pid'],
          "name": e['name'],
          "desc": e['desc'],
          "content": e['content'],
          "status": e['status'],
          "addtime": e['addtime'],
          "thum_url": e['thum_url'],
          "user": e['user'],
          "user_type": e['user_type'],
          "sorts": e['sorts'],
          "is_sj": e['is_sj'],
          "examine": e['examine'],
          "issue": e['issue'],
          "study_status": e['study_status'],
          "thumb_url": e['thumb_url'],
          "chapter": chapter,
          "view_num": e['view_num'],
        });
      }).toList();

      // 刷新页面
      if (this.mounted) {
        setState(() {
          if (page == 1) {
            courseListData['data'] = [];
          }
          courseListData['page'] = page;
          courseListData['total'] = total;
          courseListData['data'].addAll(data);
        });
      }
    } catch (err) {
      ErrorInfo(
        msg: "获取课程失败",
        errInfo: err,
        path: MyApi.courseList,
      );
    }
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
                    List data = courseListData['data'];
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
}
