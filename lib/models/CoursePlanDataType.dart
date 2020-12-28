class CoursePlanDataType {
  int id;
  int classId;
  String name;
  String link;
  String key;
  int status;
  int addtime;

  CoursePlanDataType(
      {this.id,
      this.classId,
      this.name,
      this.link,
      this.key,
      this.status,
      this.addtime});

  CoursePlanDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    name = json['name'];
    link = json['link'];
    key = json['key'];
    status = json['status'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_id'] = this.classId;
    data['name'] = this.name;
    data['link'] = this.link;
    data['key'] = this.key;
    data['status'] = this.status;
    data['addtime'] = this.addtime;
    return data;
  }
}
