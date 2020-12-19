// 课程数据类型

class CourseDataType {
  ///课程id
  int id;

  ///导航id
  int pid;

  ///标题
  String name;

  ///简介
  String desc;

  ///课程介绍
  String content;

  ///添加时间
  int addtime;

  ///封面
  String thumbUrl;

  ///学习状态 1已学完 2未学习 3学习中
  int studyStatus;

  ///章节列表信息
  List<Chapter> chapter;

  ///在学人数
  int viewNum;

  CourseDataType(
      {this.id,
      this.pid,
      this.name,
      this.desc,
      this.content,
      this.addtime,
      this.thumbUrl,
      this.studyStatus,
      this.chapter,
      this.viewNum});

  CourseDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    name = json['name'];
    desc = json['desc'];
    content = json['content'];
    addtime = json['addtime'];
    thumbUrl = json['thumb_url'];
    studyStatus = json['study_status'];
    if (json['chapter'] != null) {
      chapter = new List<Chapter>();
      json['chapter'].forEach((v) {
        chapter.add(new Chapter.fromJson(v));
      });
    }
    viewNum = json['view_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['content'] = this.content;
    data['addtime'] = this.addtime;
    data['thumb_url'] = this.thumbUrl;
    data['study_status'] = this.studyStatus;
    if (this.chapter != null) {
      data['chapter'] = this.chapter.map((v) => v.toJson()).toList();
    }
    data['view_num'] = this.viewNum;
    return data;
  }
}

class Chapter {
  ///章节id
  int id;

  ///部门id
  int dId;

  ///分类id
  int pid;

  ///章节名称
  String name;

  ///添加时间
  int addtime;

  Chapter({this.id, this.dId, this.pid, this.name, this.addtime});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    name = json['name'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['addtime'] = this.addtime;
    return data;
  }
}
