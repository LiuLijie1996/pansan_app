// 答题卡

import 'package:flutter/material.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/examIssueType.dart';

class AnswerSheet extends StatelessWidget with MyScreenUtil {
  // 题目列表
  final List<ExamIssueDataType> dataList;
  final bool reminder; //是否需要错误提示
  AnswerSheet({Key key, @required this.dataList, this.reminder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 未答个数
    int not_answer_num = dataList.where((e) => e.correct == null).length;
    // 答对的题目
    var correct = dataList.where((e) => e.correct == true);
    // 答对的个数
    int correct_num = correct.length;
    // 答错个数
    int mistake_num = dataList.where((e) => e.correct == false).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("答题卡"),
      ),
      body: Container(
        padding: EdgeInsets.all(dp(20.0)),
        child: ListView(
          children: [
            reminder
                ? Text(
                    "本次作答共计${correct_num + mistake_num}题，答对$correct_num题，答错$mistake_num题，未答$not_answer_num题",
                    style: TextStyle(
                      fontSize: dp(32.0),
                    ),
                    maxLines: 2,
                  )
                : SizedBox(),
            SizedBox(height: dp(reminder ? 20.0 : 0.0)),

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
                          fontSize: dp(26.0),
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
                        reminder == false ? '已作答' : "答对了",
                        style: TextStyle(
                          fontSize: dp(26.0),
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                // 答错了
                reminder == true
                    ? Row(
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
                              fontSize: dp(26.0),
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      )
                    : Text(""),
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
                  // 判断是否需要错误提示
                  if (reminder) {
                    _color = Colors.red;
                  } else {
                    _color = Colors.blue;
                  }
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
  }
}
