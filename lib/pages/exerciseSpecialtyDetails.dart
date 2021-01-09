// 专项练习详情

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../components/MyIcon.dart';
import '../components/TestSelect.dart';
import '../components/MyProgress.dart';
import '../mixins/mixins.dart';
import '../models/IssueDataType.dart';
import '../utils/myRequest.dart';
import '../models/ExerciseDataType.dart';
import '../utils/ErrorInfo.dart';

class ExerciseSpecialtyDetails extends StatefulWidget {
  final ExerciseDataType arguments;
  ExerciseSpecialtyDetails({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  _ExerciseSpecialtyDetailsState createState() =>
      _ExerciseSpecialtyDetailsState();
}

class _ExerciseSpecialtyDetailsState extends State<ExerciseSpecialtyDetails>
    with MyScreenUtil {
  // 轮播图控制器
  SwiperController _swiperController = SwiperController();

  // 题目列表
  List<IssueDataType> dataList = [];

  //当前题目下标
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    getDataList();
  }

  // 获取数据
  getDataList() async {
    try {
      var result = await myRequest(
        path: MyApi.getQuestionList,
        data: {
          "id": widget.arguments.id,
        },
      );

      List data = result['data'];
      dataList = data.map((e) {
        bool optionIsStr = e['option'].runtimeType == String;
        bool answerIsStr = e['answer'].runtimeType == String;

        List options = optionIsStr ? json.decode(e['option']) : e['option'];
        List answer = answerIsStr ? json.decode(e['answer']) : e['answer'];

        var option = options.map((item) {
          return {
            "label": item['label'],
            "value": item['value'],
          };
        }).toList();

        return IssueDataType.fromJson({
          "id": e['id'], //id
          "stem": (e['stem']).toString(), //标题
          "type": e['type'], //题目类型
          "option": option, //题目选项
          "answer": answer, //正确答案
          "analysis": (e['analysis']).toString(), //答案解析
          "disorder": e['disorder'], //当前题目分数
          "userFavor": e['userFavor'] ?? false, //用户是否收藏
          "userAnswer": [], //用户选择的答案
          "correct": null, //用户的选择是否正确
        });
      }).toList();

      setState(() {});
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取题目失败",
        path: MyApi.getQuestionList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ExerciseDataType arguments = widget.arguments;

    if (dataList.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${arguments.name}"),
        ),
        body: MyProgress(),
      );
    }
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
        return Future.delayed(Duration()).then((value) => true);
        // return showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('你确定要退出吗？'),
        //     actions: <Widget>[
        //       FlatButton(
        //         child: Text('取消'),
        //         onPressed: () {
        //           Navigator.of(context).pop(false);
        //         },
        //       ),
        //       FlatButton(
        //         child: Text('退出'),
        //         onPressed: () {
        //           Navigator.of(context).pop(true);
        //         },
        //       ),
        //     ],
        //   ),
        // );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${arguments.name}"),
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
                    color: _currentIndex == 0 ? Colors.grey : Colors.blue,
                  ),
                ),
                onPressed: () {
                  if (_currentIndex != 0) {
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
                onPressed: () async {
                  setState(() {
                    bool userFavor = dataList[_currentIndex].userFavor;
                    dataList[_currentIndex].userFavor = !userFavor;
                  });

                  // 发送收藏请求
                  await myRequest(
                    path: MyApi.addQuestionCollect,
                    data: {
                      "id": dataList[_currentIndex].id,
                      "user_id": true,
                    },
                  );
                },
              ),

              // 答题卡
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
                    },
                  );

                  if (result != null) {
                    _swiperController.move(result);
                  }
                },
              ),

              // 下一题按钮
              FlatButton(
                child: Text(
                  "下一题",
                  style: TextStyle(
                    color: _currentIndex == dataList.length - 1
                        ? Colors.grey
                        : Colors.blue,
                  ),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  if (_currentIndex < dataList.length - 1) {
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

                  // 正确答案
                  List<String> answer = item.answer;
                  // 用户的答案
                  List<String> user_answer = item.userAnswer;

                  // 拼接正确答案
                  String _answer = '';
                  for (var i = 0; i < answer.length; i++) {
                    int length = answer.length;
                    String e = answer[i];

                    if (length - 1 == i) {
                      _answer += e;
                    } else {
                      _answer += e + '，';
                    }
                  }

                  // 拼接用户答案
                  String _user_answer = '';
                  for (var i = 0; i < user_answer.length; i++) {
                    int length = user_answer.length;
                    String e = user_answer[i];
                    if (length - 1 == i) {
                      _user_answer += e;
                    } else {
                      _user_answer += e + '，';
                    }
                  }

                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: dp(30.0),
                        right: dp(30.0),
                        top: dp(20.0),
                        bottom: dp(20.0),
                      ),
                      child: Column(
                        children: [
                          MultipleChoice(
                            data: item,
                            reminder: true, //是否需要提示
                            // disabled: true, //是否禁止点击
                            onChange: (Option choiceList) {
                              // 判断是单选还是多选
                              if (item.type == 3 || item.type == 1) {
                                item.userAnswer = [];

                                _swiperController.next();
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
                                if (array1.length != array2.length)
                                  return false;
                                for (int i = 0; i < array1.length; i++) {
                                  if (array1[i] != array2[i]) return false;
                                }
                                return true;
                              }

                              // 判断和标准答案是否相同
                              item.correct =
                                  equals(item.userAnswer, item.answer);

                              // 如果选项为空将是否正确的字段改成null，表示没选
                              if (item.userAnswer.isEmpty) {
                                item.correct = null;
                              }

                              // 刷新页面
                              setState(() {});
                            },
                          ),

                          // 答案解析
                          item.correct != null
                              ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(dp(20.0)),
                                  margin: EdgeInsets.only(top: dp(40.0)),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border: Border.all(
                                      color: Colors.grey[400],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(dp(10.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 答案解析
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: '答案解析',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ${item.analysis}',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: dp(20.0)),

                                      // 正确答案
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("正确答案：$_answer"),
                                          SizedBox(height: dp(10.0)),
                                          Text("你的答案：$_user_answer"),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Text(''),
                        ],
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
}
