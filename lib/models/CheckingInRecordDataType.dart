/// 考勤记录数据类型
class CheckingInRecordDataType {
  int id;
  int dId;
  int userId;
  int classId;
  int classTime;
  int addtime;
  int status;
  int updateTime;
  String beizu;

  CheckingInRecordDataType({
    this.id,
    this.dId,
    this.userId,
    this.classId,
    this.classTime,
    this.addtime,
    this.status,
    this.updateTime,
    this.beizu,
  });

  CheckingInRecordDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    userId = json['user_id'];
    classId = json['class_id'];
    classTime = json['class_time'];
    addtime = json['addtime'];
    status = json['status'];
    updateTime = json['update_time'];
    beizu = json['beizu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['user_id'] = this.userId;
    data['class_id'] = this.classId;
    data['class_time'] = this.classTime;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['update_time'] = this.updateTime;
    data['beizu'] = this.beizu;
    return data;
  }
}
