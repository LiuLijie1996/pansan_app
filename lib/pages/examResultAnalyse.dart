// 考试结果分析

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../models/IssueDataType.dart';
import '../mixins/mixins.dart';
import '../components/TestSelect.dart';

class ExamResultAnalyse extends StatefulWidget {
  // 题目列表
  final List<IssueDataType> dataList;

  ExamResultAnalyse({Key key, this.dataList}) : super(key: key);

  @override
  _ExamResultAnalyseState createState() => _ExamResultAnalyseState();
}

class _ExamResultAnalyseState extends State<ExamResultAnalyse>
    with MyScreenUtil {
  // 轮播图控制器
  SwiperController _swiperController = SwiperController();
  //当前题目下标
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<IssueDataType> dataList = widget.dataList;
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

    return Scaffold(
      appBar: AppBar(
        title: Text("试题解析"),
        actions: [
          FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              "答题卡",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print("答题卡");
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
        ],
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
                          disabled: true, //是否禁止点击
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
                              if (array1.length != array2.length) return false;
                              for (int i = 0; i < array1.length; i++) {
                                if (array1[i] != array2[i]) return false;
                              }
                              return true;
                            }

                            // 判断和标准答案是否相同
                            item.correct = equals(item.userAnswer, item.answer);

                            // 刷新页面
                            setState(() {});
                          },
                        ),

                        // 答案解析
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(dp(20.0)),
                          margin: EdgeInsets.only(top: dp(40.0)),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(
                              color: Colors.grey[400],
                            ),
                            borderRadius: BorderRadius.circular(dp(10.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 答案解析
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '答案解析',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${item.analysis}',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: dp(20.0)),

                              // 正确答案
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
