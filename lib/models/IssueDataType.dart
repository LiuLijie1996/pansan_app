class IssueDataType {
  int id;
  int pid;
  String name;
  int type;
  String stem;
  List<Option> option;
  List<String> answer;
  String analysis;
  int addtime;
  num disorder;
  bool userFavor;
  List<String> userAnswer;
  Object correct;

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
  String label;
  String value;

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
