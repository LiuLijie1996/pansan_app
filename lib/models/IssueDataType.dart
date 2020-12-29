class IssueDataType {
  ///题目id
  int id;

  ///考试分类id
  int pid;

  ///考试名称
  String name;

  /// 1单选 3判断 2多选 4填空
  int type;

  ///题目名称
  String stem;

  ///答案可选项
  List<Option> option;

  ///正确答案
  List<String> answer;

  ///答案解析
  String analysis;

  ///添加考试时间
  int addtime;

  ///当前题目分数
  num disorder;

  ///用户是否收藏
  bool userFavor;

  ///用户选择的答案
  List<String> userAnswer;

  ///用户选择的答案是否正确
  bool correct;

  IssueDataType(
      {this.id,
      this.pid,
      this.name,
      this.type,
      this.stem,
      this.option,
      this.answer,
      this.analysis,
      this.addtime,
      this.disorder,
      this.userFavor,
      this.userAnswer,
      this.correct});

  IssueDataType.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      pid = json['pid'];
      name = json['name'];
      type = json['type'];
      stem = json['stem'];
      if (json['option'] != null) {
        option = new List<Option>();
        json['option'].forEach((v) {
          option.add(new Option.fromJson(v));
        });
      }
      answer = json['answer'].cast<String>();
      analysis = json['analysis'];
      addtime = json['addtime'];
      disorder = json['disorder'];
      userFavor = json['userFavor'];
      userAnswer = json['userAnswer'].cast<String>();
      correct = json['correct'];
    } catch (e) {
      print("IssueDataType  $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['type'] = this.type;
    data['stem'] = this.stem;
    if (this.option != null) {
      data['option'] = this.option.map((v) => v.toJson()).toList();
    }
    data['answer'] = this.answer;
    data['analysis'] = this.analysis;
    data['addtime'] = this.addtime;
    data['disorder'] = this.disorder;
    data['userFavor'] = this.userFavor;
    data['userAnswer'] = this.userAnswer;
    data['correct'] = this.correct;
    return data;
  }
}

class Option {
  var label;
  var value;

  Option({this.label, this.value});

  Option.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
