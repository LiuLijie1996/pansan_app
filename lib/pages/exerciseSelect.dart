// 练习列表选择

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:pansan_app/components/GradientCircularProgressIndicator.dart';
import 'package:pansan_app/components/EmptyBox.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';
import 'package:pansan_app/models/NavDataType.dart';
import 'package:pansan_app/models/ExerciseSelectDataType.dart';

class ExerciseSelect extends StatefulWidget {
  final NavDataType arguments;
  ExerciseSelect({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseSelectState createState() => _ExerciseSelectState();
}

class _ExerciseSelectState extends State<ExerciseSelect>
    with SingleTickerProviderStateMixin, MyScreenUtil {
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
      duration: Duration(seconds: 5), //持续时间
    );

    // 设置曲线
    animation = CurvedAnimation(curve: Curves.easeIn, parent: _controller);
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
        title: Text("${widget.arguments.name}"),
        centerTitle: true,
      ),
      body: exerciseData['data'].length == 0
          ? myWidget[_currentMyWidget]
          : ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                var dataItem = exerciseData['data'][index];
                ExerciseSelectDataType item = ExerciseSelectDataType.fromJson(
                  dataItem,
                );

                //添加时间
                String _addtime;
                try {
                  DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
                    item.addtime * 1000,
                  );

                  //格式化添加时间
                  _addtime = formatDate(
                    addtime,
                    [yyyy, '年', mm, '月', dd, '日'],
                  );
                } catch (e) {
                  print("报错信息：$e");
                }

                String scale;
                try {
                  scale = "${(item.progress * 100).ceil()}%";
                } catch (e) {
                  print("报错信息：$e");
                }

                double progress = Tween(
                  begin: 0.0,
                  end: double.parse("${item.progress}"),
                ).animate(animation).value;
                return Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: ListTile(
                    leading: Container(
                      width: dp(100.0),
                      height: dp(100.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GradientCircularProgressIndicator(
                            colors: [
                              Colors.blue[200],
                              Colors.blue,
                            ],
                            radius: dp(50.0),
                            stokeWidth: dp(10.0),
                            strokeCapRound: true,
                            value: progress, //进度
                          ),
                          Text("$scale"),
                        ],
                      ),
                    ),
                    title: Text(
                      "${item.name}",
                      style: TextStyle(
                        fontSize: dp(32.0),
                      ),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: dp(20.0)),
                      child: Text("$_addtime"),
                    ),
                    trailing: RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(dp(100.0)),
                      ),
                      onPressed: () {
                        print("去答题");
                        Navigator.pushNamed(
                          context,
                          "/exerciseDetails",
                          arguments: item,
                        );
                      },
                      child: Text(
                        "去答题",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
        path: "/api/exercise/getPracticeList",
        data: {
          "id": widget.arguments.id,
          "user_id": 1,
        },
      );
      int total = result['total'] ?? 0;
      List data = result['data'];

      List newData = data.map((e) {
        return {
          "id": e['id'],
          "d_id": e['d_id'],
          "pid": e['pid'],
          "name": e['name'],
          "radio": e['radio'],
          "multiple": e['multiple'],
          "trueOrFalse": e['trueOrFalse'],
          "practice_num_type": e['practice_num_type'],
          "frequency": e['frequency'],
          "q_id": e['q_id'],
          "addtime": e['addtime'],
          "status": e['status'],
          "progress": e['progress'],
          "sorts": e['sorts']
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
