// 单选和判断题的数据类型
import 'package:flutter/cupertino.dart';

// 题目选择项的数据类型
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
  final num disorder; //当前题目分数
  bool userFavor; //用户是否收藏
  List<String> user_answer; //用户选择的答案
  bool correct; //选择的答案是否正确

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
        correct = map['correct'];

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
    };
  }
}

// 考试列表项数据类型
class ExamItemDataType {
  final String test_id; //考试id
  final String title; //考试标题
  final int status; //考试状态 0未开始 1进行中 2已结束
  final int type; //考试类型， 1模拟 2正式 3补考
  final start_date; //开始时间
  final end_date; //结束时间

  ExamItemDataType({
    @required this.test_id,
    @required this.title,
    @required this.status,
    @required this.type,
    @required this.start_date,
    @required this.end_date,
  });

  ExamItemDataType.fromJson(Map<String, dynamic> map)
      : test_id = map['test_id'],
        title = map['title'],
        status = map['status'],
        type = map['type'],
        start_date = map['start_date'],
        end_date = map['end_date'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "test_id": test_id,
      "title": title,
      "status": status,
      "type": type,
      "start_date": start_date,
      "end_date": end_date,
    };
  }
}

// 考场信息数据类型
class ExamSiteDataType {
  final String id; // 考试id
  final String title; //考试标题
  final int type; // 考试类型
  final String address; // 考试地址
  final int duration; // 考试限时
  final int passing_mark; // 及格分数
  final int test_num; // 考试次数
  final int cut_screen_type; // 是否开启切屏限制  1开启切屏限制
  final int cut_screen_num; // 考试时切屏最大次数
  final int cut_screen_time; // 考试切屏时最大等待时间

  ExamSiteDataType({
    @required this.id, // 考试id
    @required this.title, //考试标题
    @required this.type, // 考试类型
    @required this.address, // 考试地址
    @required this.duration, // 考试限时
    @required this.passing_mark, // 及格分数
    @required this.test_num, // 考试次数
    @required this.cut_screen_type, // 是否开启切屏限制  1开启切屏限制
    @required this.cut_screen_num, // 考试时切屏最大次数
    @required this.cut_screen_time, // 考试切屏时最大等待时间
  });

  ExamSiteDataType.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        type = map['type'],
        address = map['address'],
        duration = map['duration'],
        passing_mark = map['passing_mark'],
        test_num = map['test_num'],
        cut_screen_type = map['cut_screen_type'],
        cut_screen_num = map['cut_screen_num'],
        cut_screen_time = map['cut_screen_time'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "title": title,
      "type": type,
      "address": address,
      "duration": duration,
      "passing_mark": passing_mark,
      "test_num": test_num,
      "cut_screen_type": cut_screen_type,
      "cut_screen_num": cut_screen_num,
      "cut_screen_time": cut_screen_time,
    };
  }
}
