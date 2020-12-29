// 试题收藏页面

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../mixins/withScreenUtil.dart';
import '../models/IssueDataType.dart';
import '../components/TestSelect.dart';
import '../components/EmptyBox.dart';
import '../components/MyIcon.dart';
import '../utils/myRequest.dart';
import '../components/MyProgress.dart';

class QuestionsCollect extends StatefulWidget {
  QuestionsCollect({Key key}) : super(key: key);

  @override
  _QuestionsCollectState createState() => _QuestionsCollectState();
}

class _QuestionsCollectState extends State<QuestionsCollect> with MyScreenUtil {
// 轮播图控制器
  SwiperController _swiperController = SwiperController();
  //当前题目下标
  int _currentIndex = 0;

  // 收藏的试题列表
  List<IssueDataType> questionsCollectList = [];

  bool initialize = false; //初始化是否完成

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    // 获取收藏的试题
    getQuestionCollect();
  }

  // 获取收藏的试题
  getQuestionCollect() async {
    try {
      var result = await myRequest(
        path: MyApi.getQuestionCollect,
        data: {
          "user_id": 1,
        },
      );

      List data = result['data']['list'];
      questionsCollectList = data.map((e) {
        // 判断这些数组是不是被改成String类型了
        bool optionIsStr = e['option'].runtimeType == String;
        bool answerIsStr = e['answer'].runtimeType == String;

        // 将String类型的数组改回数组类型
        List options = optionIsStr ? json.decode(e['option']) : e['option'];
        List answer = answerIsStr ? json.decode(e['answer']) : e['answer'];

        return IssueDataType.fromJson({
          "id": e['id'], //id
          "stem": e['stem'], //标题
          "type": e['type'], //题目类型
          "option": options, //题目选项
          "answer": answer, //正确答案
          "analysis": e['analysis'], //答案解析
          "disorder": e['disorder'], //当前题目分数
          "userFavor": e['userFavor'] ?? false, //用户是否收藏
          "userAnswer": [], //用户选择的答案
          "correct": null, //用户的选择是否正确
        });
      }).toList();

      if (this.mounted) {
        initialize = true;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!initialize) {
      return Scaffold(
        body: MyProgress(),
      );
    }

    if (questionsCollectList.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("我的收藏"),
        ),
        body: EmptyBox(),
      );
    }

    // 当前显示的题目
    IssueDataType _currentItem = questionsCollectList[_currentIndex];
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

    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/questionsCorrection",
                arguments: {
                  "issueData": questionsCollectList[_currentIndex],
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
                        questionsCollectList[_currentIndex].userFavor
                            ? aliIconfont.full_collect
                            : aliIconfont.collect,
                        color: questionsCollectList[_currentIndex].userFavor
                            ? Colors.red
                            : Colors.blue,
                        size: dp(40.0),
                      ),
                    ),
                    Text(
                      questionsCollectList[_currentIndex].userFavor
                          ? "已收藏"
                          : "收藏",
                      style: TextStyle(
                        color: questionsCollectList[_currentIndex].userFavor
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
                  bool userFavor =
                      questionsCollectList[_currentIndex].userFavor;
                  questionsCollectList[_currentIndex].userFavor = !userFavor;
                });
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
                        aliIconfont.correct,
                        color: Colors.blue,
                        size: dp(40.0),
                      ),
                    ),
                    Text(
                      "答题卡",
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
                // 跳转到答题卡
                var result = await Navigator.pushNamed(
                  context,
                  '/answerSheet',
                  arguments: {
                    "dataList": questionsCollectList,
                    "reminder": true,
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
                  color: _currentIndex == questionsCollectList.length - 1
                      ? Colors.grey
                      : Colors.blue,
                ),
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                if (_currentIndex < questionsCollectList.length - 1) {
                  _swiperController.next();
                }
              },
            ),
          ],
        ),
      ),
      body: questionsCollectList.length == 0
          ? EmptyBox()
          : Column(
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
                        "${_currentIndex + 1}/${questionsCollectList.length}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // 问题轮播
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
                    itemCount: questionsCollectList.length,
                    itemBuilder: (BuildContext context, int index) {
                      IssueDataType item = questionsCollectList[index];

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

                                    if (_currentIndex <
                                        questionsCollectList.length - 1) {
                                      _swiperController.next();
                                    }
                                  }

                                  // 判断当前选择的是否已经选择过了
                                  bool is_select = item.userAnswer
                                      .contains(choiceList.label);
                                  // 如果已经选了，那么就删除
                                  if (is_select) {
                                    int index = item.userAnswer
                                        .indexOf(choiceList.label);

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
                              _currentItem.correct == null
                                  ? Container()
                                  : Container(
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
                                              style:
                                                  DefaultTextStyle.of(context)
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
                                                  style: TextStyle(
                                                      color: Colors.red),
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
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
