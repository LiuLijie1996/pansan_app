// 练习详情

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/examIssueType.dart';
import 'package:pansan_app/components/TestSelect.dart';
import 'package:pansan_app/components/MyIcon.dart';

// 模拟的数据
import 'package:pansan_app/models/mockData.dart';

class ExerciseDetails extends StatefulWidget {
  final Map arguments;

  ExerciseDetails({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseDetailsState createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> with MyScreenUtil {
  // 轮播图控制器
  SwiperController _swiperController = SwiperController();
  // 定时器
  Timer _timer;
  // 练习消耗的时间
  int expend_time = 0;

  // 题目列表
  List<ExamIssueDataType> dataList = [];

  //当前题目下标
  int _currentIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    getDataList();

    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      expend_time++;
    });
  }

  @override
  void dispose() {
    print("清除定时器");
    // 清除定时器
    _timer.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 当前显示的题目
    ExamIssueDataType _currentItem = dataList[_currentIndex - 1];
    // 1单选 3判断 2多选 4填空
    String textType = '';
    if (_currentItem.type == 1) {
      textType = '单选';
    } else if (_currentItem.type == 2) {
      textType = '多选';
    } else if (_currentItem.type == 3) {
      textType = '判断';
    } else {
      textType = '填空';
    }

    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('你确定要退出吗？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('退出'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("技术人员测试"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/questionsCorrection",
                  arguments: {
                    "issueData": dataList[_currentIndex - 1],
                  },
                );
              },
              child: Text(
                "纠错",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // 上一题按钮
              FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  "上一题",
                  style: TextStyle(
                    color: _currentIndex == 1 ? Colors.grey : Colors.blue,
                  ),
                ),
                onPressed: () {
                  if (_currentIndex - 1 != 0) {
                    _swiperController.previous();
                  }
                },
              ),
              // 收藏按钮
              FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: UnconstrainedBox(
                  child: Column(
                    children: [
                      SizedBox(height: dp(5.0)),
                      Container(
                        margin: EdgeInsets.only(bottom: dp(6.0)),
                        child: Icon(
                          dataList[_currentIndex - 1].userFavor
                              ? myIcon['full_collect']
                              : myIcon['collect'],
                          color: dataList[_currentIndex - 1].userFavor
                              ? Colors.red
                              : Colors.blue,
                          size: dp(40.0),
                        ),
                      ),
                      Text(
                        dataList[_currentIndex - 1].userFavor ? "已收藏" : "收藏",
                        style: TextStyle(
                          color: dataList[_currentIndex - 1].userFavor
                              ? Colors.red
                              : Colors.blue,
                          fontSize: dp(28.0),
                        ),
                      ),
                      SizedBox(height: dp(5.0)),
                    ],
                  ),
                ),
                onPressed: () {
                  setState(() {
                    bool userFavor = dataList[_currentIndex - 1].userFavor;
                    dataList[_currentIndex - 1].userFavor = !userFavor;
                  });
                },
              ),
              // 交卷按钮
              FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: UnconstrainedBox(
                  child: Column(
                    children: [
                      SizedBox(height: dp(5.0)),
                      Container(
                        margin: EdgeInsets.only(bottom: dp(6.0)),
                        child: Icon(
                          myIcon['correct'],
                          color: Colors.blue,
                          size: dp(40.0),
                        ),
                      ),
                      Text(
                        "交卷",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: dp(28.0),
                        ),
                      ),
                      SizedBox(height: dp(5.0)),
                    ],
                  ),
                ),
                onPressed: () async {
                  print("点击交卷");
                  // 如果没有做完 is_over 会被赋值 false
                  int where = dataList.where((e) => e.correct == null).length;
                  bool is_over = where == 0;

                  // 弹窗提示
                  var result = await showDialogFunc(is_over);
                  print("result $result");

                  if (result == true) {
                    // 跳转到 答题报告（练习结束）
                    Navigator.pushReplacementNamed(
                      context,
                      "/exerciseOver",
                      arguments: {
                        "dataList": dataList,
                        "expend_time": expend_time,
                      },
                    );
                  }
                },
              ),
              // 下一题按钮
              FlatButton(
                child: Text(
                  "下一题",
                  style: TextStyle(
                    color: _currentIndex == dataList.length
                        ? Colors.grey
                        : Colors.blue,
                  ),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  if (_currentIndex < dataList.length) {
                    _swiperController.next();
                  }
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: dp(30.0),
                bottom: dp(30.0),
                left: dp(20.0),
                right: dp(20.0),
              ),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$textType",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "$_currentIndex/${dataList.length}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              //轮播
              child: Swiper(
                loop: false,
                controller: _swiperController,
                onIndexChanged: (int index) {
                  setState(() {
                    _currentIndex = index + 1;
                  });
                },
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  ExamIssueDataType item = dataList[index];

                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: dp(30.0),
                        right: dp(30.0),
                        top: dp(20.0),
                        bottom: dp(20.0),
                      ),
                      child: MultipleChoice(
                        data: item,
                        reminder: true, //是否需要提示
                        // disabled: true, //是否禁止点击
                        onChange: (ChoiceList choiceList) {
                          // 判断是单选还是多选
                          if (item.type == 3 || item.type == 1) {
                            item.user_answer = [];

                            _swiperController.next();
                          }

                          // 判断当前选择的是否已经选择过了
                          bool is_select =
                              item.user_answer.contains(choiceList.label);
                          // 如果已经选了，那么就删除
                          if (is_select) {
                            int index =
                                item.user_answer.indexOf(choiceList.label);

                            // 删除选项
                            item.user_answer.removeAt(index);
                          } else {
                            // 如果没有选择，就添加选项
                            item.user_answer.add(choiceList.label);
                          }

                          // 数组排序
                          item.user_answer.sort((left, right) {
                            return left.compareTo(right);
                          });

                          // 判断两数组的值是否相同
                          bool equals(List array1, List array2) {
                            if (array1.length != array2.length) return false;
                            for (int i = 0; i < array1.length; i++) {
                              if (array1[i] != array2[i]) return false;
                            }
                            return true;
                          }

                          // 判断和标准答案是否相同
                          item.correct = equals(item.user_answer, item.answer);

                          // 如果选项为空将是否正确的字段改成null，表示没选
                          if (item.user_answer.isEmpty) {
                            item.correct = null;
                          }

                          // 刷新页面
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取数据
  getDataList() {
    // listData 获取到的考题
    dataList = listData.map((e) {
      List options = e['option'];
      List<ChoiceList> option = options.map((item) {
        return ChoiceList(
          label: item['label'],
          value: item['value'],
        );
      }).toList();

      return ExamIssueDataType(
        id: e['id'], //id
        stem: e['stem'], //标题
        type: e['type'], //题目类型
        option: option, //题目选项
        answer: e['answer'], //正确答案
        analysis: e['analysis'], //答案解析
        disorder: e['disorder'], //当前题目分数
        userFavor: e['userFavor'], //用户是否收藏
        user_answer: [], //用户选择的答案
        correct: null, //用户的选择是否正确
      );
    }).toList();

    setState(() {});
  }

  // 弹窗
  Future<bool> showDialogFunc(bool is_over) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text(is_over ? "确认交卷吗？" : '题目还没有做完，是否确认交卷？'),
          actions: [
            FlatButton(
              onPressed: () {
                // 关闭对话框，第二个参数是传入的数据
                Navigator.pop(context, false);
              },
              child: Text("取消"),
            ),
            FlatButton(
              onPressed: () {
                // 关闭对话框，第二个参数是传入的数据
                Navigator.pop(context, true);
              },
              child: Text("确定"),
            ),
          ],
        );
      },
    );
  }
}
