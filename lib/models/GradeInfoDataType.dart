/// 班级信息数据类型
class GradeInfoDataType {
  int classId;
  String name;

  GradeInfoDataType.fromJson(Map json) {
    this.classId = json['class_id'];
    this.name = json['name'];
  }

  toJson() {
    return {
      "class_id": this.classId,
      "name": this.name,
    };
  }
}
