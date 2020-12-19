// 练习列表数据

class ExerciseSelectDataType {
  int id;
  int dId;
  int pid;

  ///标题
  String name;

  ///单选题个数
  int radio;

  ///多选题个数
  int multiple;

  ///判断题个数
  int trueOrFalse;

  ///练习次数 1无限  2一次  3多次
  int practiceNumType;

  ///答题次数
  int frequency;

  ///题目id
  String qId;

  ///添加时间
  int addtime;
  int status;
  String sorts;

  ///比例
  num progress;

  ///是否能点击
  bool is_practice;

  ExerciseSelectDataType({
    this.id,
    this.dId,
    this.pid,
    this.name,
    this.radio,
    this.multiple,
    this.trueOrFalse,
    this.practiceNumType,
    this.frequency,
    this.qId,
    this.addtime,
    this.status,
    this.sorts,
    this.progress,
    this.is_practice,
  });

  ExerciseSelectDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    name = json['name'];
    radio = json['radio'];
    multiple = json['multiple'];
    trueOrFalse = json['trueOrFalse'];
    practiceNumType = json['practice_num_type'];
    frequency = json['frequency'];
    qId = json['q_id'];
    addtime = json['addtime'];
    status = json['status'];
    sorts = json['sorts'];
    progress = json['progress'];
    is_practice = json['is_practice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['radio'] = this.radio;
    data['multiple'] = this.multiple;
    data['trueOrFalse'] = this.trueOrFalse;
    data['practice_num_type'] = this.practiceNumType;
    data['frequency'] = this.frequency;
    data['q_id'] = this.qId;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['sorts'] = this.sorts;
    data['progress'] = this.progress;
    data['is_practice'] = this.is_practice;
    return data;
  }
}
