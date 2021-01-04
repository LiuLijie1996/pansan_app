// 练习列表选择

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import '../components/GradientCircularProgressIndicator.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../models/NavDataType.dart';
import '../models/ExerciseSelectDataType.dart';
import '../utils/ErrorInfo.dart';

class ExerciseSelect extends StatefulWidget {
  final NavDataType arguments;
  ExerciseSelect({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseSelectState createState() => _ExerciseSelectState();
}

class _ExerciseSelectState extends State<ExerciseSelect>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  // 声明 AnimationController
  AnimationController _controller;
  Animation animation;

  ///初始化是否完成
  bool isInitialize = false;

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

    // 初始化
    this.myInitialize();
  }

  // 初始化
  myInitialize() {
    // 设置动画控制器
    setController();

    // 获取练习列表
    getDataList();
  }

  // 设置动画控制器
  setController() {
    // 初始化 controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), //持续时间
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
  }

  // 获取练习列表
  getDataList({page = 1}) async {
    try {
      var result = await myRequest(
        path: MyApi.getPracticeList,
        data: {
          "id": widget.arguments.id,
          "user_id": true,
        },
      );
      int total = result['total'] ?? 0;
      List data = result['data'];

      List newData = data.map((e) {
        return ExerciseSelectDataType.fromJson({
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
        });
      }).toList();

      if (this.mounted) {
        isInitialize = true;
        if (page == 1) {
          exerciseData['data'] = [];
        }
        exerciseData['page'] = page;
        exerciseData['total'] = total;
        exerciseData['data'].addAll(newData);

        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取练习列表失败",
        path: MyApi.getPracticeList,
      );
    }
  }

  @override
  void dispose() {
    // 清除动画
    _controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialize) {
      return Scaffold(
        body: MyProgress(),
      );
    }

    if (exerciseData['data'].length == 0) {
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
          ExerciseSelectDataType item = exerciseData['data'][index];

          //添加时间
          DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
            item.addtime * 1000,
          );

          //格式化添加时间
          String _addtime = formatDate(
            addtime,
            [yyyy, '年', mm, '月', dd, '日'],
          );

          String scale = "${(item.progress * 100).ceil()}%";

          // 进度
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
}
