// 专项练习列表选择

import 'dart:async';
import 'package:flutter/material.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../models/ExerciseDataType.dart';
import '../utils/ErrorInfo.dart';

class ExerciseSpecialtySelect extends StatefulWidget {
  final ExerciseDataType arguments;
  ExerciseSpecialtySelect({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseSpecialtySelectState createState() =>
      _ExerciseSpecialtySelectState();
}

class _ExerciseSpecialtySelectState extends State<ExerciseSpecialtySelect>
    with MyScreenUtil {
  ///初始化是否完成
  bool isInitialize = false;

  Map exercisesData = {
    "page": 1,
    "psize": 20,
    "total": 0,
    "data": [],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    getDataList();
  }

  // 获取专项练习列表
  getDataList({page = 1}) async {
    try {
      Map<String, dynamic> query = {};
      // 判断有没有id 如果有id，传入id给后台
      if (widget.arguments.id != null) {
        query['id'] = widget.arguments.id;
      }
      var result = await myRequest(
        path: MyApi.getAllQuestionItemList,
        data: query,
      );
      int total = result['total'] ?? 0;
      List data = result['data'];

      List newData = data.map((e) {
        return ExerciseDataType.fromJson({
          "id": e['id'],
          "d_id": e['d_id'],
          "pid": e['pid'],
          "name": e['name'],
          "addtime": e['addtime'],
          "sorts": e['sorts'],
          "status": e['status'],
          "isview": e['isview'],
          "type": e['type'],
          "isOk": e['isOk'],
          "isChildren": e['isChildren']
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          isInitialize = true;
          if (page == 1) {
            exercisesData['data'] = [];
          }
          exercisesData['page'] = page;
          exercisesData['total'] = total;
          exercisesData['data'].addAll(newData);
        });
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取专项练习列表失败",
        path: MyApi.getAllQuestionItemList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialize) {
      return Scaffold(
        body: MyProgress(),
      );
    }

    if (exercisesData['data'].length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${widget.arguments.name}"),
          centerTitle: true,
        ),
        body: EmptyBox(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.arguments.name}"),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          ExerciseDataType item = exercisesData['data'][index];
          return ListTile(
            title: Text("${item.name}"),
            onTap: () {
              if (item.isChildren == true) {
                // 跳转到专项练习列表选择页
                Navigator.pushNamed(
                  context,
                  "/exerciseSpecialtySelect",
                  arguments: item,
                );
              } else {
                // 跳转到答题页面
                Navigator.pushNamed(
                  context,
                  "/exerciseSpecialtyDetails",
                  arguments: item,
                );
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
        itemCount: exercisesData['data'].length,
      ),
    );
  }
}
