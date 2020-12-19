class DayTopicDataType {
  ///时间线上的时间
  int time;

  ///时间线上的成员列表
  List<Child> child;

  DayTopicDataType({this.time, this.child});

  DayTopicDataType.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['child'] != null) {
      child = new List<Child>();
      json['child'].forEach((v) {
        child.add(new Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    if (this.child != null) {
      data['child'] = this.child.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  ///状态 1已学习  2未学习
  int status;

  ///标题
  String name;

  ///id
  int id;

  ///具体时间
  int studyTime;

  Child({this.status, this.name, this.id, this.studyTime});

  Child.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    name = json['name'];
    id = json['id'];
    studyTime = json['study_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['name'] = this.name;
    data['id'] = this.id;
    data['study_time'] = this.studyTime;
    return data;
  }
}
