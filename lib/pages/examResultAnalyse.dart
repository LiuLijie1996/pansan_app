// 考试结果分析

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:pansan_app/models/examIssueType.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/components/TestSelect.dart';

class ExamResultAnalyse extends StatefulWidget {
  // 题目列表
  final List<ExamIssueDataType> dataList;

  ExamResultAnalyse({Key key, this.dataList}) : super(key: key);

  @override
  _ExamResultAnalyseState createState() => _ExamResultAnalyseState();
}

class _ExamResultAnalyseState extends State<ExamResultAnalyse>
    with MyScreenUtil {
  // 轮播图控制器
  SwiperController _swiperController = SwiperController();
  //当前题目下标
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    List<ExamIssueDataType> dataList = widget.dataList;
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
              int result = await answerSheetAlter();
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

                // 正确答案
                List<String> answer = item.answer;
                // 用户的答案
                List<String> user_answer = item.user_answer;

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
                            item.correct =
                                equals(item.user_answer, item.answer);

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
                              Row(
                                children: [
                                  Text("正确答案："),
                                  Text("$_answer，"),
                                  Text("你答案："),
                                  Text("$_user_answer"),
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

  // 答题卡弹窗
  answerSheetAlter() {
    List<ExamIssueDataType> dataList = widget.dataList;
    return showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("答题卡"),
          ),
          body: Container(
            padding: EdgeInsets.all(dp(20.0)),
            child: ListView(
              children: [
                Text(
                  "本次作答共计8题，答对3题，答错5题，未答0题",
                  style: TextStyle(
                    fontSize: dp(32.0),
                  ),
                ),
                SizedBox(height: dp(20.0)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 未答的
                    Container(
                      margin: EdgeInsets.only(right: dp(20.0)),
                      child: Row(
                        children: [
                          Container(
                            width: dp(20.0),
                            height: dp(20.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(dp(10.0)),
                            ),
                          ),
                          SizedBox(width: dp(5.0)),
                          Text(
                            "未答题",
                            style: TextStyle(
                              fontSize: dp(20.0),
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 答对的
                    Container(
                      margin: EdgeInsets.only(right: dp(20.0)),
                      child: Row(
                        children: [
                          Container(
                            width: dp(20.0),
                            height: dp(20.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(dp(10.0)),
                            ),
                          ),
                          SizedBox(width: dp(5.0)),
                          Text(
                            "答对了",
                            style: TextStyle(
                              fontSize: dp(20.0),
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 答错了
                    Row(
                      children: [
                        Container(
                          width: dp(20.0),
                          height: dp(20.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(dp(10.0)),
                          ),
                        ),
                        SizedBox(width: dp(5.0)),
                        Text(
                          "答错了",
                          style: TextStyle(
                            fontSize: dp(20.0),
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: dp(50.0)),

                // 选项卡
                Wrap(
                  spacing: dp(30.0),
                  runSpacing: dp(30.0),
                  children: dataList.map((e) {
                    Color _color = Colors.grey;
                    // 获取下标
                    int index = dataList.indexOf(e);

                    if (e.correct == true) {
                      _color = Colors.blue;
                    } else if (e.correct == false) {
                      _color = Colors.red;
                    }

                    return InkWell(
                      child: CircleAvatar(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                        radius: dp(50.0),
                        backgroundColor: _color,
                      ),
                      onTap: () {
                        Navigator.pop(context, index);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
