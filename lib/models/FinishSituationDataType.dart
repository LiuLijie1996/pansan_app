///完成情况数据类型
class FinishSituationDataType {
  int id;
  int courseId;
  int chapterId;
  int articleId;
  int userId;
  int departmentId;
  int duration;
  int status;
  int addtime;
  int type;
  int finishTime;
  int updateTime;
  User user;

  ///1学习完成  2未学习  3学习中
  int studyStatus;

  FinishSituationDataType(
      {this.id,
      this.courseId,
      this.chapterId,
      this.articleId,
      this.userId,
      this.departmentId,
      this.duration,
      this.status,
      this.addtime,
      this.type,
      this.finishTime,
      this.updateTime,
      this.user,
      this.studyStatus});

  FinishSituationDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    chapterId = json['chapter_id'];
    articleId = json['article_id'];
    userId = json['user_id'];
    departmentId = json['department_id'];
    duration = json['duration'];
    status = json['status'];
    addtime = json['addtime'];
    type = json['type'];
    finishTime = json['finish_time'];
    updateTime = json['update_time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    studyStatus = json['studyStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['chapter_id'] = this.chapterId;
    data['article_id'] = this.articleId;
    data['user_id'] = this.userId;
    data['department_id'] = this.departmentId;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['addtime'] = this.addtime;
    data['type'] = this.type;
    data['finish_time'] = this.finishTime;
    data['update_time'] = this.updateTime;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['studyStatus'] = this.studyStatus;
    return data;
  }
}

class User {
  int id;
  String name;
  int department;

  User({this.id, this.name, this.department});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['department'] = this.department;
    return data;
  }
}
