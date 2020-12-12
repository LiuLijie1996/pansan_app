// 专项练习列表选择

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/utils/myRequest.dart';

class ExerciseSpecialtySelect extends StatefulWidget {
  final Map arguments;
  ExerciseSpecialtySelect({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseSpecialtySelectState createState() =>
      _ExerciseSpecialtySelectState();
}

class _ExerciseSpecialtySelectState extends State<ExerciseSpecialtySelect> {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

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

    // 倒计时
    timer = Timer(Duration(seconds: 5), () {
      setState(() {
        _currentMyWidget = 1;
      });
    });

    // 请求数据
    getDataList();
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
        title: Text("${widget.arguments['name']}"),
        centerTitle: true,
      ),
      body: exercisesData['data'].length == 0
          ? myWidget[_currentMyWidget]
          : ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Map item = exercisesData['data'][index];
                return ListTile(
                  title: Text("${item['name']}"),
                  onTap: () {
                    if (item['is_child'] == true) {
                      // 跳转到专项练习列表选择页
                      Navigator.pushNamed(
                        context,
                        "/exerciseSpecialtySelect",
                        arguments: item,
                      );
                    } else {
                      print("跳转到答题页面");
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

  // 获取专项练习列表
  getDataList({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/test/exerciseSpecialtySelect",
        data: widget.arguments['id'] == 0
            ? {}
            : {
                "id": widget.arguments['id'],
              },
      );
      int total = result['total'] ?? 0;
      List data = result['data'];

      List newData = data.map((e) {
        return {
          "id": e['id'],
          "name": e['name'],
          "is_child": e['is_child'],
        };
      }).toList();

      if (this.mounted) {
        setState(() {
          if (page == 1) {
            exercisesData['data'] = [];
          }
          exercisesData['page'] = page;
          exercisesData['total'] = total;
          exercisesData['data'].addAll(newData);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
