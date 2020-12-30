///一日一题详情数据类型
class DayTopicDetailDataType {
  int id;
  int dId;
  String name;
  int studyTime;
  int addtime;
  String content;
  String analysis;
  int status;

  DayTopicDetailDataType({
    this.id,
    this.dId,
    this.name,
    this.studyTime,
    this.addtime,
    this.content,
    this.analysis,
    this.status,
  });

  DayTopicDetailDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    name = json['name'];
    studyTime = json['study_time'];
    addtime = json['addtime'];
    content = json['content'];
    analysis = json['analysis'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['name'] = this.name;
    data['study_time'] = this.studyTime;
    data['addtime'] = this.addtime;
    data['content'] = this.content;
    data['analysis'] = this.analysis;
    data['status'] = this.status;
    return data;
  }
}
