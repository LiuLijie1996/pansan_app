// 课程计划

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pansan_app/utils/fileMethod.dart';
import '../models/CoursePlanDataType.dart';
import '../utils/myRequest.dart';
import '../models/GradeInfoDataType.dart';
import '../mixins/withScreenUtil.dart';

class CoursePlan extends StatefulWidget {
  GradeInfoDataType arguments;
  CoursePlan({Key key, @required this.arguments}) : super(key: key);

  @override
  _CoursePlanState createState() => _CoursePlanState();
}

class _CoursePlanState extends State<CoursePlan> with MyScreenUtil {
  GradeInfoDataType arguments;
  List<CoursePlanDataType> coursePlanList = [];

  @override
  void initState() {
    super.initState();
    arguments = widget.arguments;

    // 获取课程计划
    getCoursePlan();
  }

  // 获取课程计划
  getCoursePlan() async {
    try {
      var result = await myRequest(
        path: MyApi.getTimeTableList,
        data: {
          "class_id": arguments.classId,
        },
      );

      List data = result['data'];
      coursePlanList = data.map((e) {
        return CoursePlanDataType.fromJson({
          "id": e['id'],
          "class_id": e['class_id'],
          "name": e['name'],
          "link": e['link'],
          "key": e['key'],
          "status": e['status'],
          "addtime": e['addtime'],
        });
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("课程计划"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: coursePlanList.length,
          itemBuilder: (context, index) {
            CoursePlanDataType item = coursePlanList[index];
            return Container(
              padding: EdgeInsets.all(dp(30.0)),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: dp(1.0),
                    color: Colors.grey[200],
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name),
                  Row(
                    children: [
                      SizedBox(
                        height: dp(60.0),
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            // 查看文件
                            showFile(
                              context: context,
                              link: item.link,
                              title: "课程计划预览",
                            );
                          },
                          child: Text(
                            "查看",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: dp(20.0)),
                      SizedBox(
                        height: dp(60.0),
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            // 下载文件
                            downloadFile(link: item.link);
                          },
                          child: Text(
                            "下载",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
