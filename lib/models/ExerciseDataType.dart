// 专项练习列表数据类型

class ExerciseDataType {
  int id;
  int dId;
  int pid;
  String name;
  int addtime;
  String sorts;
  int status;
  int isview;
  int type;
  bool isOk;
  bool isChildren;

  ExerciseDataType({
    this.id,
    this.dId,
    this.pid,
    this.name,
    this.addtime,
    this.sorts,
    this.status,
    this.isview,
    this.type,
    this.isOk,
    this.isChildren,
  });

  ExerciseDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    name = json['name'];
    addtime = json['addtime'];
    sorts = json['sorts'];
    status = json['status'];
    isview = json['isview'];
    type = json['type'];
    isOk = json['isOk'];
    isChildren = json['isChildren'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['addtime'] = this.addtime;
    data['sorts'] = this.sorts;
    data['status'] = this.status;
    data['isview'] = this.isview;
    data['type'] = this.type;
    data['isOk'] = this.isOk;
    data['isChildren'] = this.isChildren;
    return data;
  }
}
