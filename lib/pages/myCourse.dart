// 我的课程

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/CardItem.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/CourseDataType.dart';

class MyCourse extends StatefulWidget {
  MyCourse({Key key}) : super(key: key);

  @override
  _MyCourseState createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> with MyScreenUtil {
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  bool initialize = false; //初始化是否完成
  int page = 1;
  int psize = 20;
  int total = 0;
  List<CourseDataType> courseDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // 初始化
  myInitialize() async {
    // 请求数据
    getCourseData();
  }

  // 请求数据
  Future getCourseData({
    int page = 1,
  }) async {
    try {
      var result = await myRequest(
        context: context,
        path: MyApi.getUserCourseList,
        data: {
          "user_id": 1,
          "page": page,
          "psize": psize,
        },
      );
      List data = result['data'];
      total = result['total'];

      List<CourseDataType> newData = data.map((e) {
        return CourseDataType.fromJson({
          "id": e['course']['id'], //id
          "thumb_url": e['thum_url'], //封面图
          "name": e['name'], //标题
          "status": e['status'], //状态，是否学完
          "view_num": e['view_num'], //学习人数
          "addtime": e['addtime'], //添加时间
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          initialize = true;
          courseDataList.addAll(newData);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialize == false) {
      return Scaffold(
        body: MyProgress(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("我的课程"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        // 下拉刷新的回调
        onRefresh: () {
          page = 1;
          courseDataList = [];
          return getCourseData(page: page);
        },
        child: courseDataList.length == 0
            ? EmptyBox()
            : Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: courseDataList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    CourseDataType item;

                    try {
                      item = courseDataList[index];
                    } catch (e) {
                      // 判断后台有没有数据了
                      if (courseDataList.length == total) {
                        return MyProgress(status: false);
                      }

                      // 请求数据
                      getCourseData(page: ++page);
                      return MyProgress();
                    }

                    return CourseCardItem(
                      onClick: () {},
                      item: item,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
