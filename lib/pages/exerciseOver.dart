import 'package:flutter/material.dart';
import 'package:pansan_app/models/examIssueType.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/components/MyIcon.dart';

// 答题报告（练习结束）
class ExerciseOver extends StatelessWidget with MyScreenUtil {
  // 题目列表
  final List<ExamIssueDataType> dataList;
  // 练习消耗的时间
  int expend_time;
  ExerciseOver({Key key, @required this.dataList, @required this.expend_time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 未答个数
    int not_answer_num = dataList.where((e) => e.correct == null).length;
    // 正确的个数
    int correct_num = dataList.where((e) => e.correct == true).length;
    // 答错个数
    int mistake_num = dataList.where((e) => e.correct == false).length;
    // 正确率
    int correct_rate = (correct_num / dataList.length * 100).floor();

    // 分钟
    int minute = (expend_time / 60).floor();
    // 秒
    int second = expend_time % 60;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("答题报告"),
      ),
      body: Container(
        padding: EdgeInsets.all(dp(30.0)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(dp(30.0)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dp(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 未答的
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$not_answer_num',
                                  style: TextStyle(
                                    fontSize: dp(50.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '题',
                                  style: TextStyle(
                                    fontSize: dp(26.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: dp(5.0)),
                          Row(
                            children: [
                              Container(
                                width: dp(20.0),
                                height: dp(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(dp(20.0)),
                                ),
                              ),
                              SizedBox(width: dp(5.0)),
                              Text(
                                "未答题",
                                style: TextStyle(
                                  fontSize: dp(28.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // 答对的
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$correct_num',
                                  style: TextStyle(
                                    fontSize: dp(50.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '题',
                                  style: TextStyle(
                                    fontSize: dp(26.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: dp(5.0)),
                          Row(
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
                                  fontSize: dp(28.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // 答错了
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$mistake_num',
                                  style: TextStyle(
                                    fontSize: dp(50.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '题',
                                  style: TextStyle(
                                    fontSize: dp(26.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: dp(5.0)),
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
                                  fontSize: dp(28.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // 正确率
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$correct_rate',
                                  style: TextStyle(
                                    fontSize: dp(50.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    fontSize: dp(26.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: dp(5.0)),
                          Row(
                            children: [
                              Text(
                                "正确率",
                                style: TextStyle(
                                  fontSize: dp(28.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 考试消耗时长
                  Container(
                    margin: EdgeInsets.only(top: dp(30.0)),
                    child: Row(
                      children: [
                        Icon(
                          aliIconfont.chronograph,
                          size: dp(30.0),
                        ),
                        SizedBox(width: dp(10.0)),
                        Text(
                          "用时${minute <= 9 && minute > 0 ? '0' + minute.toString() : minute}分${second <= 9 ? '0' + second.toString() : second}秒",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: dp(28.0),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 底部按钮
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: dp(50.0)),
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  // 跳转到试题解析页面
                  Navigator.pushNamed(
                    context,
                    "/examResultAnalyse",
                    arguments: {
                      "dataList": dataList,
                    },
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  '查看解析结果',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
