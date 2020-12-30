// 考试结束页面
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../components/MyTags.dart';
import '../mixins/withScreenUtil.dart';
import '../models/IssueDataType.dart';
import '../models/ExamListDataType.dart';
import '../utils/myRequest.dart';

class ExamOver extends StatelessWidget with MyScreenUtil {
  // 题目列表
  final List<IssueDataType> dataList;
  // 考场信息
  final ExamListDataType examSiteInfo;
  // 练习消耗的时间
  int expend_time;
  ExamOver({
    Key key,
    @required this.dataList,
    @required this.examSiteInfo,
    @required this.expend_time,
  }) : super(key: key);

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
    // 总得分
    num total_points = correct.fold(
      0,
      (curr, next) {
        return curr + next.disorder;
      },
    );

    // 小时
    int hour = (expend_time / 60 / 24).floor();
    String _hour = hour <= 9 ? "0$hour" : "$hour";
    // 分钟
    int minute = (expend_time / 60).floor();
    String _minute = minute <= 9 ? "0$minute" : "$minute";
    // 秒
    int second = expend_time % 60;
    String _second = second <= 9 ? "0$second" : "$second";

    // 是否及格
    bool passing_mark = examSiteInfo.passingMark <= total_points;
    // 考试类型
    String examType = examSiteInfo.type == 1
        ? '模拟考试'
        : examSiteInfo.type == 2
            ? '正式考试'
            : examSiteInfo.type == 3
                ? '补考'
                : '';

    // 当前时间
    var now = formatDate(
      new DateTime.now(),
      [yyyy, '年', mm, '月', dd, '日'],
    );

    var newDataList = dataList.map((e) {
      var option = e.option.map((ele) => ele.toJson()).toList();
      return {
        ...e.toJson(),
        "option": option,
      };
    }).toList();
    var query = {
      "user_id": 1, //用户id
      "test_id": examSiteInfo.id, //考试id
      "fraction": total_points, //总得分
      "type": passing_mark, //考试是否及格
      "data": newDataList, //所有考试题目
    };

    // 提交试卷
    myRequest(context: context, path: MyApi.saveUserTest, data: query)
        .then((value) {
      print(value);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("答题报告"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(dp(20.0)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(dp(20.0)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(dp(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 头部
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    // 总得分
                    Text(
                      "$total_points",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: dp(100.0),
                      ),
                    ),
                    SizedBox(width: dp(20.0)),
                    // 是否及格
                    Column(
                      children: [
                        // 是否及格
                        MyTags(
                          radius: BorderRadius.only(
                            topLeft: Radius.circular(
                              dp(20.0),
                            ),
                            bottomRight: Radius.circular(
                              dp(30.0),
                            ),
                          ),
                          bgColor: passing_mark ? Colors.blue : Colors.red,
                          title: passing_mark ? "及格" : '不及格',
                        ),
                        Container(
                          width: dp(120.0),
                          margin: EdgeInsets.only(top: dp(10.0)),
                          child: Text("分"),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // 考试类型
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: dp(20.0)),
                child: Text(
                  "$examType",
                  style: TextStyle(
                    fontSize: dp(30.0),
                  ),
                ),
              ),

              // 消耗时间
              Container(
                margin: EdgeInsets.only(top: dp(20.0)),
                child: Row(
                  children: [
                    Text(
                      "$_hour时$_minute分$_second秒",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: dp(28.0),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(width: dp(50.0)),
                    Text(
                      "$now",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: dp(28.0),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: dp(50.0)),
                child: Row(
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
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: dp(50.0)),
                child: Text("本次答题共计 ${correct_num + mistake_num} 题，加油！"),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: dp(100.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlineButton(
                      child: Text(
                        "返回上一页",
                        style: TextStyle(color: Colors.blue),
                      ),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
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
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      color: Colors.blue,
                      child: Text(
                        "查看解析结果",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
