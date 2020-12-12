// 练习列表选择

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:pansan_app/components/GradientCircularProgressIndicator.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/utils/myRequest.dart';

class ExerciseSelect extends StatefulWidget {
  final Map arguments;
  ExerciseSelect({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseSelectState createState() => _ExerciseSelectState();
}

class _ExerciseSelectState extends State<ExerciseSelect>
    with SingleTickerProviderStateMixin {
  Timer timer;
  int _currentMyWidget = 0;
  List myWidget = [MyProgress(), EmptyBox()];

  // 声明 AnimationController
  AnimationController _controller;
  Animation animation;

  Map exerciseData = {
    "page": 1,
    "psize": 20,
    "total": 0,
    "data": [],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化 controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), //持续时间
    );

    // 设置曲线
    animation = CurvedAnimation(curve: Curves.bounceIn, parent: _controller);
    // 添加监听器
    animation.addListener(() {
      setState(() {});
    });

    _controller
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.dismissed:
            print("动画在起点停止");

            // 终点停止时，在正向执行
            _controller.forward();
            break;
          case AnimationStatus.completed:
            print("动画在终点停止");

            // 终点停止时，在反向执行
            // _controller.reverse();
            break;
          case AnimationStatus.forward:
            print("动画在正向执行");
            break;
          case AnimationStatus.reverse:
            print("动画在反向执行");
            break;
        }
      })
      ..forward();

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
    // 清除动画
    _controller.dispose();

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
      body: exerciseData['data'].length == 0
          ? myWidget[_currentMyWidget]
          : ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Map item = exerciseData['data'][index];
                double progress = double.parse("${item['progress'] / 100}");
                return Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GradientCircularProgressIndicator(
                            colors: [
                              Colors.blue[100],
                              Colors.blue,
                            ],
                            radius: 25.0,
                            stokeWidth: 5.0,
                            strokeCapRound: true,
                            value: progress,
                          ),
                          Text("${item['progress']}%"),
                        ],
                      ),
                    ),
                    title: Text(
                      "${item['name']}",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text("${item['add_time']}"),
                    ),
                    trailing: RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onPressed: () {
                        print("去答题");
                      },
                      child: Text(
                        "去答题",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      print("跳转到答题页面");
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: exerciseData['data'].length,
            ),
    );
  }

  // 获取练习列表
  getDataList({page = 1}) async {
    try {
      var result = await myRequest(
        path: "/api/test/exerciseSelect",
        data: {
          "id": widget.arguments['id'],
        },
      );
      int total = result['total'] ?? 0;
      List data = result['data'];

      List newData = data.map((e) {
        //添加时间
        DateTime add_time = DateTime.fromMillisecondsSinceEpoch(
          e['add_time'] * 1000,
        );

        //格式化添加时间
        String _add_time = formatDate(
          add_time,
          [yyyy, '年', mm, '月', dd, '日'],
        );

        return {
          "id": e['id'],
          "name": e['name'], //标题
          "progress": e['progress'], //进度
          "add_time": _add_time, //添加时间
        };
      }).toList();

      if (this.mounted) {
        if (page == 1) {
          exerciseData['data'] = [];
        }
        exerciseData['page'] = page;
        exerciseData['total'] = total;
        exerciseData['data'].addAll(newData);
      }
    } catch (e) {
      print(e);
    }
  }
}
