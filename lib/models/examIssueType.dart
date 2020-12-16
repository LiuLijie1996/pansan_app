// 单选和判断题的数据类型
import 'package:flutter/cupertino.dart';

// 题目选择时的列表项数据类型
class ChoiceList {
  final String label;
  final String value;

  ChoiceList({
    this.label,
    this.value,
  });

  ChoiceList.fromJson(Map<String, dynamic> map)
      : label = map['label'],
        value = map['value'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "label": label,
      "value": value,
    };
  }
}

//考试问题的数据类型
class ExamIssueDataType {
  final int id; //题目id
  final String stem; //标题
  final int type; //题目类型 3判断
  final List<ChoiceList> option; //选项
  final List<String> answer; //正确答案
  final String analysis; //答案解析
  final String disorder; //当前题目分数
  bool userFavor; //用户是否收藏
  List<String> user_answer; //用户选择的答案
  bool correct; //选择的答案是否正确
  int expend_time; //考试所用时长

  ExamIssueDataType({
    @required this.id,
    @required this.stem,
    @required this.type,
    @required this.option,
    @required this.answer,
    @required this.analysis,
    @required this.disorder,
    @required this.userFavor,
    @required this.user_answer,
    @required this.correct,
    @required this.expend_time,
  });

  ExamIssueDataType.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        stem = map['stem'],
        type = map['type'],
        option = map['option'],
        answer = map['answer'],
        analysis = map['analysis'],
        disorder = map['disorder'],
        userFavor = map['userFavor'],
        user_answer = map['user_answer'],
        correct = map['correct'],
        expend_time = map['expend_time'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "stem": stem,
      "type": type,
      "option": option,
      "answer": answer,
      "analysis": analysis,
      "disorder": disorder,
      "userFavor": userFavor,
      "user_answer": user_answer,
      "correct": correct,
      "expend_time": expend_time,
    };
  }
}
