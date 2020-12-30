// 考勤记录

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../models/CheckingInRecordDataType.dart';
import '../utils/myRequest.dart';
import '../models/GradeInfoDataType.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/ErrorInfo.dart';

class CheckingInRecord extends StatefulWidget {
  GradeInfoDataType arguments;
  CheckingInRecord({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  _CheckingInRecordState createState() => _CheckingInRecordState();
}

class _CheckingInRecordState extends State<CheckingInRecord> with MyScreenUtil {
  GradeInfoDataType arguments;
  List<CheckingInRecordDataType> checkingInRecordList = [];

  @override
  void initState() {
    super.initState();

    arguments = widget.arguments;

    // 获取考勤记录
    getCheckingInRecord();
  }

  // 获取考勤记录
  getCheckingInRecord() async {
    try {
      var result = await myRequest(
        path: MyApi.getAttendDetail,
        data: {
          "user_id": true,
          "class_id": arguments.classId,
        },
      );

      // 如果返回null说明已经跳转到登录页了，没有任何数据返回
      if (result == null) return;

      List data = result['data'];
      checkingInRecordList = data.map((e) {
        return CheckingInRecordDataType.fromJson({
          "id": e['id'],
          "d_id": e['d_id'],
          "user_id": e['user_id'],
          "class_id": e['class_id'],
          "class_time": e['class_time'],
          "addtime": e['addtime'],
          "status": e['status'],
          "update_time": e['update_time'],
          "beizu": e['beizu'],
        });
      }).toList();

      if (this.mounted) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("考勤记录"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: checkingInRecordList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.all(dp(30.0)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200],
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("考勤次数"),
                    Text("考勤时间"),
                  ],
                ),
              );
            }

            CheckingInRecordDataType item = checkingInRecordList[index - 1];

            String _addtime = '未签到';
            if (item.addtime != 0) {
              DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
                item.addtime * 1000,
              );
              _addtime = formatDate(
                addtime,
                [yyyy, '-', mm, '-', dd, " ", HH, ":", mm],
              );
            }

            return Container(
              padding: EdgeInsets.all(dp(30.0)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("第${checkingInRecordList.length + 1 - index}次"),
                  Text("$_addtime"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
