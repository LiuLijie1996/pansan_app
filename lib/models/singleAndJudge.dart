// 单选和判断题的数据类型
import 'package:flutter/cupertino.dart';
import 'package:pansan_app/models/choiceList.dart';

class SingleAndJudge {
  final int id; //题目id
  final String stem; //标题
  final List<ChoiceList> option; //选项
  final String answer; //正确答案
  final String analysis; //答案解析
  final String disorder; //当前题目分数
  final bool userFavor; //用户是否收藏

  SingleAndJudge({
    @required this.id,
    @required this.stem,
    @required this.option,
    @required this.answer,
    @required this.analysis,
    @required this.disorder,
    @required this.userFavor,
  });

  SingleAndJudge.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        stem = map['stem'],
        option = map['option'],
        answer = map['answer'],
        analysis = map['analysis'],
        disorder = map['disorder'],
        userFavor = map['userFavor'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "stem": stem,
      "option": option,
      "answer": answer,
      "analysis": analysis,
      "disorder": disorder,
      "userFavor": userFavor,
    };
  }
}
