import 'package:flutter/material.dart';
import '../models/CourseDataType.dart';
import '../utils/ErrorInfo.dart';
import '../utils/myRequest.dart';
import '../components/MyProgress.dart';
import '../components/EmptyBox.dart';
import '../models/FinishSituationDataType.dart';

/// 完成情况
class FinishSituation extends StatefulWidget {
  final CourseDataType arguments;
  FinishSituation({Key key, @required this.arguments}) : super(key: key);

  @override
  _FinishSituationState createState() => _FinishSituationState();
}

class _FinishSituationState extends State<FinishSituation> {
  List<FinishSituationDataType> dataList = [];
  int page = 1;
  int psize = 20;
  int total = 0;
  bool isInitialize = false; //初始化是否完成

  @override
  void initState() {
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    // 请求数据
    getDataList();
  }

  // 获取数据
  getDataList({
    page = 1,
  }) async {
    try {
      var result = await myRequest(
        path: MyApi.courseSituation,
        data: {
          "id": widget.arguments.id,
          "page": page,
          "psize": psize,
        },
      );

      total = result['total'];
      List data = result['data'];
      List<FinishSituationDataType> newData = data.map((e) {
        int duration;
        if (e['duration'] != null) {
          duration = double.parse("${e['duration']}").ceil();
        }

        return FinishSituationDataType.fromJson({
          "id": e['id'],
          "course_id": e['course_id'],
          "chapter_id": e['chapter_id'],
          "article_id": e['article_id'],
          "user_id": e['user_id'],
          "department_id": e['department_id'],
          "duration": duration,
          "status": e['status'],
          "addtime": e['addtime'],
          "type": e['type'],
          "finish_time": e['finish_time'],
          "update_time": e['update_time'],
          "user": {
            "id": e['user']['id'],
            "name": e['user']['name'],
            "department": e['user']['department'],
          },
          "studyStatus": e['studyStatus']
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          isInitialize = true;
          if (page == 1) {
            dataList = [];
          }
          dataList.addAll(newData);
        });
      }
    } catch (e) {
      ErrorInfo(
        msg: "获取失败",
        errInfo: e,
        path: MyApi.courseSituation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialize) {
      return Scaffold(
        appBar: AppBar(
          title: Text("完成情况"),
          centerTitle: true,
        ),
        body: MyProgress(),
      );
    }

    if (total == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("完成情况"),
          centerTitle: true,
        ),
        body: EmptyBox(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("完成情况"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: dataList.length + 1,
        itemBuilder: (context, index) {
          FinishSituationDataType item;

          try {
            item = dataList[index];
          } catch (e) {
            // 判断后台是否还有数据
            if (total == dataList.length) {
              return MyProgress(status: false);
            }

            // 请求下一页数据
            getDataList(page: ++page);
            return MyProgress();
          }

          String studyStatus;
          Color color;
          if (item.studyStatus == 1) {
            studyStatus = "已学完";
            color = Colors.blue;
          } else if (item.studyStatus == 2) {
            studyStatus = "未学习";
            color = Colors.grey;
          } else if (item.studyStatus == 3) {
            studyStatus = "学习中";
            color = Colors.green;
          }

          String sort = (index + 1).toString();
          if (index + 1 < 10) {
            sort = '0' + sort;
          }

          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200],
                ),
              ),
            ),
            child: ListTile(
              leading: Text(
                "$sort",
                style: TextStyle(color: Colors.grey),
              ),
              title: Text("${item.user.name}"),
              trailing: Text(
                "$studyStatus",
                style: TextStyle(color: color),
              ),
            ),
          );
        },
      ),
    );
  }
}
