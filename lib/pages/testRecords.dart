// 考试记录

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/MyIcon.dart';
import '../components/MyProgress.dart';
import '../components/EmptyBox.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/TestRecordsDataType.dart';
import '../models/IssueDataType.dart';
import '../utils/ErrorInfo.dart';

class TestRecords extends StatefulWidget {
  TestRecords({Key key}) : super(key: key);

  @override
  _TestRecordsState createState() => _TestRecordsState();
}

class _TestRecordsState extends State<TestRecords> with MyScreenUtil {
  List<TestRecordsDataType> testRecordsData = [];
  bool initialize = false; //初始化是否完成

  _TestRecordsState() {
    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() async {
    // 获取记录列表
    getTestRecordsData();
  }

  // 获取记录列表
  getTestRecordsData() async {
    try {
      var result = await myRequest(
        path: MyApi.getUserTestRecordList,
        data: {
          "user_id": true,
        },
      );
      List data = result['data'];

      testRecordsData = data.map((e) {
        return TestRecordsDataType.fromJson({
          "id": e['id'],
          "test_id": e['test_id'],
          "user_id": e['user_id'],
          "department_id": e['department_id'],
          "m_test_id": e['m_test_id'],
          "type": e['type'],
          "fraction": e['fraction'],
          "test_time": e['test_time'],
          "addtime": e['addtime'],
          "sorts": e['sorts'],
          "update_time": e['update_time'],
          "test_type": e['test_type'],
          "option": e['option'],
          "q_group": e['q_group'],
          "test_num": e['test_num'],
          "test": {
            "id": e['test']['id'],
            "d_id": e['test']['d_id'],
            "mid": e['test']['mid'],
            "pid": e['test']['pid'],
            "m_test_id": e['test']['m_test_id'],
            "class_id": e['test']['class_id'],
            "paper_id": e['test']['paper_id'],
            "name": e['test']['name'],
            "address": e['test']['address'],
            "min_duration": e['test']['min_duration'],
            "duration": e['test']['duration'],
            "passing_mark": e['test']['passing_mark'],
            "test_num_type": e['test']['test_num_type'],
            "test_num": e['test']['test_num'],
            "cut_screen_type": e['test']['cut_screen_type'],
            "cut_screen_num": e['test']['cut_screen_num'],
            "cut_screen_time": e['test']['cut_screen_time'],
            "user_type": e['test']['user_type'],
            "type": e['test']['type'],
            "is_integral": e['test']['is_integral'],
            "integral": e['test']['integral'],
            "integral_type": e['test']['integral_type'],
            "score_rule": e['test']['score_rule'],
            "sorts": e['test']['sorts'],
            "status": e['test']['status'],
            "addtime": e['test']['addtime']
          }
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          initialize = true;
        });
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取考试记录失败",
        path: MyApi.getUserTestRecordList,
      );
    }
  }

  // 获取考试记录对应的考题
  Future<List<IssueDataType>> getUserTestAnswerList({
    ///考试id
    @required test_id,

    ///考试类型
    @required test_type,
  }) async {
    try {
      var result = await myRequest(
        path: MyApi.getUserTestAnswerList,
        data: {
          "user_id": true,
          "test_id": test_id,
          "test_type": test_type,
        },
      );

      List data = result['data']['list'];

      List<IssueDataType> newData = data.map((e) {
        // 判断这些数组是不是被改成String类型了
        bool optionIsStr = e['option'].runtimeType == String;
        bool answerIsStr = e['answer'].runtimeType == String;

        // 将String类型的数组改回数组类型
        List options = optionIsStr ? json.decode(e['option']) : e['option'];
        List answer = answerIsStr ? json.decode(e['answer']) : e['answer'];

        bool correct;
        if (e['q_type'] == 1) {
          correct = null;
        } else if (e['q_type'] == 2) {
          correct = false;
        } else if (e['q_type'] == 3) {
          correct = true;
        }

        return IssueDataType.fromJson({
          "id": e['id'], //id
          "stem": e['stem'], //标题
          "type": e['type'], //题目类型
          "option": options, //题目选项
          "answer": answer, //正确答案
          "analysis": e['analysis'], //答案解析
          "disorder": e['disorder'], //当前题目分数
          "userFavor": e['userFavor'] ?? false, //用户是否收藏
          "userAnswer": e['userAnswer'], //用户选择的答案
          "correct": correct, //用户的选择是否正确
        });
      }).toList();

      return newData;
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取考题失败",
        path: MyApi.getUserTestAnswerList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 判断初始化是否完成
    if (!initialize) {
      return Scaffold(
        body: MyProgress(),
      );
    }

    if (testRecordsData.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("考试记录"),
          centerTitle: true,
        ),
        body: EmptyBox(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("考试记录"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            TestRecordsDataType item = testRecordsData[index];

            // 格式化时间
            DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
              item.addtime * 1000,
            );
            String _addtime = formatDate(
              addtime,
              [yyyy, '-', mm, '-', dd, " ", HH, ":", mm],
            );

            return InkWell(
              onTap: () async {
                print("获取考题");

                // 获取考题
                List<IssueDataType> result = await getUserTestAnswerList(
                  test_id: item.testId,
                  test_type: item.testType,
                );

                if (result != null) {
                  // 跳转到试题解析页面
                  Navigator.pushNamed(
                    context,
                    "/examResultAnalyse",
                    arguments: {
                      "dataList": result,
                    },
                  );
                }
              },
              child: ListTile(
                title: Text(
                  "${item.test.name}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("$_addtime"),
                trailing: Container(
                  width: dp(180.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item.fraction} 分",
                        style: TextStyle(fontSize: dp(32.0)),
                      ),
                      Icon(
                        aliIconfont.arrows_right,
                        size: dp(30.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: testRecordsData.length,
        ),
      ),
    );
  }
}
