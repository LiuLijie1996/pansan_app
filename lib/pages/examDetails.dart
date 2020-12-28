// 考试详情页

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pansan_app/components/ErrorInfo.dart';
import '../components/MyIcon.dart';
import '../components/MyProgress.dart';
import '../components/TestSelect.dart';
import '../mixins/withScreenUtil.dart';
import '../models/ExamListDataType.dart';
import '../models/IssueDataType.dart';
import '../utils/myRequest.dart';

class ExamDetails extends StatefulWidget {
  final ExamListDataType examSiteInfo;
  ExamDetails({Key key, @required this.examSiteInfo}) : super(key: key);

  @override
  _ExamDetailsState createState() => _ExamDetailsState();
}

class _ExamDetailsState extends State<ExamDetails>
    with MyScreenUtil, WidgetsBindingObserver {
  ExamListDataType examSiteInfo;

  // 轮播图控制器
  SwiperController _swiperController = SwiperController();
  // 定时器(记录考试消耗时长)
  Timer _timer;
  // 考试消耗的时间
  int expend_time = 1;

  // 定时器（记录应用回到后台消耗时长）
  Timer _timerApp;
  // 应用在后台停留的时间
  int _appTime = 0;
  // 应用进入后台的次数
  int _appCount = 0;

  // 题目列表
  List<IssueDataType> dataList = [];

  //当前题目下标
  int _currentIndex = 0;

  ///最小考试时间
  int minDuration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 监听应用生命周期
    WidgetsBinding.instance.addObserver(this);

    // 获取父类接收的数据
    examSiteInfo = widget.examSiteInfo;
    // 最小考试时间
    minDuration = widget.examSiteInfo.minDuration;

    // 请求数据
    getDataList();

    // 考试计时
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      expend_time++;
      minDuration--;

      // 判断考试是否结束了
      if (expend_time >= examSiteInfo.duration) {
        // 考试结束 跳转到考试结束页面
        toExamOverPage();
      } else {
        setState(() {});
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // APP进入后台，

      // 判断切屏次数
      _appCount++;
      if (_appCount >= examSiteInfo.cutScreenNum) {
        // 弹出提示
        fn() async {
          await _showLeaveNumAlert("离开应用次数过多，自动交卷");
          print("跳转到考试结束页");
          toExamOverPage();
        }

        fn();
      } else {
        // 定时器，判断时间是否过长
        _timerApp = Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            // 记录在后台运行的时间
            _appTime++;
            print("$_appTime");
          },
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      // APP进入前台
      print('APP进入前台 ${examSiteInfo.cutScreenTime}');
      if (_appTime >= examSiteInfo.cutScreenTime) {
        // 弹出提示
        fn() async {
          await _showLeaveNumAlert("离开考试时间过长，自动交卷");
          print("跳转到考试结束页");
          toExamOverPage();
        }

        fn();
      } else {
        _appTime = 0;
      }
      _timerApp.cancel();
    } else if (state == AppLifecycleState.inactive) {
      // print('应用处于非激活状态，并且未接收用户时调用，比如：来电话');
    }
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // 清除定时器
    _timer.cancel();
    // 清除定时器
    _timerApp?.cancel();

    //移除监听器
    WidgetsBinding.instance.removeObserver(this);

    // TODO: implement dispose
    super.dispose();
  }

  // 获取数据
  getDataList() async {
    try {
      var result = await myRequest(
        path: "/api/exam/kaoTi",
        data: {
          "user_id": 1,
          "id": examSiteInfo.id,
          "type": examSiteInfo.type,
        },
      );
      print("获取数据：${result['data']}");

      List data = result['data']['list'];

      dataList = data.map((e) {
        List options = json.decode(e['option']);

        List<Option> option = options.map((item) {
          Map<String, dynamic> newItem = {
            "label": item['label'],
            "value": item['value'],
          };
          return Option.fromJson(newItem);
        }).toList();

        List answer = e['answer'] ?? [];
        List<String> newAnswer = answer.map((item) {
          return item.toString();
        }).toList();

        return IssueDataType(
          id: e['id'], //id
          stem: e['stem'], //标题
          type: e['type'], //题目类型
          option: option, //题目选项
          answer: newAnswer, //正确答案
          analysis: e['analysis'], //答案解析
          disorder: e['disorder'], //当前题目分数
          userFavor: e['userFavor'], //用户是否收藏
          userAnswer: [], //用户选择的答案
          correct: null, //用户的选择是否正确
        );
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
      ErrorInfo(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dataList.length == 0) {
      return Scaffold(
        body: MyProgress(),
      );
    }

    // 考试剩余的时间
    int remainTime = examSiteInfo.duration - expend_time;
    int minute = (remainTime / 60).floor(); //分钟
    int second = remainTime % 60; //秒
    String _minute = minute <= 9 ? '0$minute' : "$minute";
    String _second = second <= 9 ? '0$second' : "$second";

    // 当前显示的题目
    IssueDataType _currentItem = dataList[_currentIndex];
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
        // 判断最少交卷时间是否到达
        if (minDuration <= 0) {
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
                    // 跳转到考试结束页
                    toExamOverPage();
                  },
                ),
              ],
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "$minDuration秒后才能交卷",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          return Future.delayed(Duration()).then((value) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("$_minute:$_second"),
          centerTitle: true,
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/questionsCorrection",
                  arguments: {
                    "issueData": dataList[_currentIndex],
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
          child: Flex(
            direction: Axis.horizontal, //水平方向布局
            children: <Widget>[
              // 上一题按钮
              Expanded(
                flex: 1,
                child: UnconstrainedBox(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text(
                      "上一题",
                      style: TextStyle(
                        color: _currentIndex == 0 ? Colors.grey : Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      if (_currentIndex != 0) {
                        _swiperController.previous();
                      }
                    },
                  ),
                ),
              ),

              // 收藏按钮
              Expanded(
                flex: 1,
                child: UnconstrainedBox(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: UnconstrainedBox(
                      child: Column(
                        children: [
                          SizedBox(height: dp(5.0)),
                          Container(
                            margin: EdgeInsets.only(bottom: dp(6.0)),
                            child: Icon(
                              dataList[_currentIndex].userFavor
                                  ? aliIconfont.full_collect
                                  : aliIconfont.collect,
                              color: dataList[_currentIndex].userFavor
                                  ? Colors.red
                                  : Colors.blue,
                              size: dp(40.0),
                            ),
                          ),
                          Text(
                            dataList[_currentIndex].userFavor ? "已收藏" : "收藏",
                            style: TextStyle(
                              color: dataList[_currentIndex].userFavor
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
                        bool userFavor = dataList[_currentIndex].userFavor;
                        dataList[_currentIndex].userFavor = !userFavor;
                      });
                    },
                  ),
                ),
              ),

              // 答题卡
              Expanded(
                flex: 1,
                child: UnconstrainedBox(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: UnconstrainedBox(
                      child: Column(
                        children: [
                          SizedBox(height: dp(5.0)),
                          Container(
                            margin: EdgeInsets.only(bottom: dp(6.0)),
                            child: Icon(
                              aliIconfont.answer_sheet,
                              color: Colors.blue,
                              size: dp(40.0),
                            ),
                          ),
                          Text(
                            "答题卡",
                            style: TextStyle(color: Colors.blue),
                          ),
                          SizedBox(height: dp(5.0)),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      var result = await Navigator.pushNamed(
                        context,
                        '/answerSheet',
                        arguments: {
                          "dataList": dataList,
                          "reminder": false,
                        },
                      );

                      if (result != null) {
                        _swiperController.move(result);
                      }
                    },
                  ),
                ),
              ),

              // 交卷按钮
              Expanded(
                flex: 1,
                child: UnconstrainedBox(
                  child: FlatButton(
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
                      // 判断最小考试时间是否完成
                      if (minDuration <= 0) {
                        print("点击交卷");

                        // 如果没有做完 is_over 会被赋值 false
                        int where =
                            dataList.where((e) => e.correct == null).length;
                        bool is_over = where == 0;

                        // 弹窗提示
                        var result = await showDialogFunc(is_over);
                        print("result $result");

                        if (result == true) {
                          //跳转到考试结束页面
                          toExamOverPage();
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "$minDuration秒后才能交卷",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                  ),
                ),
              ),

              // 下一题按钮
              // Expanded(
              //   flex: 1,
              //   child: UnconstrainedBox(
              //     child: FlatButton(
              //       child: Text(
              //         "下一题",
              //         style: TextStyle(
              //           color: _currentIndex == dataList.length - 1
              //               ? Colors.grey
              //               : Colors.blue,
              //         ),
              //       ),
              //       splashColor: Colors.transparent,
              //       highlightColor: Colors.transparent,
              //       onPressed: () {
              //         if (_currentIndex < dataList.length - 1) {
              //           _swiperController.next();
              //         }
              //       },
              //     ),
              //   ),
              // ),
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
                    "${_currentIndex + 1}/${dataList.length}",
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
                    _currentIndex = index;
                  });
                },
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  IssueDataType item = dataList[index];

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
                        // reminder: true, //是否需要提示
                        // disabled: true, //是否禁止点击
                        onChange: (Option choiceList) {
                          // 判断是单选还是多选
                          if (item.type == 3 || item.type == 1) {
                            item.userAnswer = [];

                            // 判断是不是最后一题
                            if (_currentIndex != dataList.length - 1) {
                              _swiperController.next();
                            }
                          }

                          // 判断当前选择的是否已经选择过了
                          bool is_select =
                              item.userAnswer.contains(choiceList.label);
                          // 如果已经选了，那么就删除
                          if (is_select) {
                            int index =
                                item.userAnswer.indexOf(choiceList.label);

                            // 删除选项
                            item.userAnswer.removeAt(index);
                          } else {
                            // 如果没有选择，就添加选项
                            item.userAnswer.add(choiceList.label);
                          }

                          // 数组排序
                          item.userAnswer.sort((left, right) {
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
                          item.correct = equals(item.userAnswer, item.answer);

                          // 如果选项为空将是否正确的字段改成null，表示没选
                          if (item.userAnswer.isEmpty) {
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

  // 交卷弹窗
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

  // 切屏次数超出后或离开时间太长时弹窗
  Future _showLeaveNumAlert(String msg) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("$msg"),
        );
      },
    );
  }

  // 跳转到考试结束页面
  toExamOverPage() {
    try {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(
        context,
        "/examOver",
        arguments: {
          "dataList": dataList,
          "expend_time": expend_time,
          "examSiteInfo": widget.examSiteInfo,
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
