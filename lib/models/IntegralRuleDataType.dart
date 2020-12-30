///积分规则数据类型
class IntegralRuleDataType {
  int id;
  String name;

  /// 1登录  2考试  3看新闻  5课程  6一日一题
  int type;
  int upperLimit;
  int addtime;
  int updateTime;
  int status;
  int sorts;
  List<IntegralRuleChild> child;

  IntegralRuleDataType({
    this.id,
    this.name,
    this.type,
    this.upperLimit,
    this.addtime,
    this.updateTime,
    this.status,
    this.sorts,
    this.child,
  });

  IntegralRuleDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    upperLimit = json['upper_limit'];
    addtime = json['addtime'];
    updateTime = json['update_time'];
    status = json['status'];
    sorts = json['sorts'];
    if (json['child'] != null) {
      child = new List<IntegralRuleChild>();
      json['child'].forEach((v) {
        child.add(new IntegralRuleChild.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['upper_limit'] = this.upperLimit;
    data['addtime'] = this.addtime;
    data['update_time'] = this.updateTime;
    data['status'] = this.status;
    data['sorts'] = this.sorts;
    if (this.child != null) {
      data['child'] = this.child.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IntegralRuleChild {
  int id;
  int pid;
  String name;
  int num;
  int score;
  int frequency;
  int mark1;
  int mark2;
  int addtime;
  int type;
  int status;
  int sorts;
  int upperLimit;

  IntegralRuleChild(
      {this.id,
      this.pid,
      this.name,
      this.num,
      this.score,
      this.frequency,
      this.mark1,
      this.mark2,
      this.addtime,
      this.type,
      this.status,
      this.sorts,
      this.upperLimit});

  IntegralRuleChild.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    name = json['name'];
    num = json['num'];
    score = json['score'];
    frequency = json['frequency'];
    mark1 = json['mark1'];
    mark2 = json['mark2'];
    addtime = json['addtime'];
    type = json['type'];
    status = json['status'];
    sorts = json['sorts'];
    upperLimit = json['upper_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['num'] = this.num;
    data['score'] = this.score;
    data['frequency'] = this.frequency;
    data['mark1'] = this.mark1;
    data['mark2'] = this.mark2;
    data['addtime'] = this.addtime;
    data['type'] = this.type;
    data['status'] = this.status;
    data['sorts'] = this.sorts;
    data['upper_limit'] = this.upperLimit;
    return data;
  }
}
