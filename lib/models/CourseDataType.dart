/// 课程数据类型
class CourseDataType {
  ///课程id
  int id;
  int dId;

  ///导航id
  int pid;

  ///标题
  String name;

  ///简介
  String desc;

  ///课程介绍
  String content;
  int status;

  ///添加时间
  int addtime;

  ///封面图
  String thumUrl;
  String user;
  int userType;
  String sorts;
  int isSj;
  int examine;
  int issue;

  ///学习状态 1已学完 2未学习 3学习中
  int studyStatus;

  ///封面
  String thumbUrl;

  ///章节列表信息
  List<Chapter> chapter;

  ///在学人数
  int viewNum;

  CourseDataType(
      {this.id,
      this.dId,
      this.pid,
      this.name,
      this.desc,
      this.content,
      this.status,
      this.addtime,
      this.thumUrl,
      this.user,
      this.userType,
      this.sorts,
      this.isSj,
      this.examine,
      this.issue,
      this.studyStatus,
      this.thumbUrl,
      this.chapter,
      this.viewNum});

  CourseDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    name = json['name'];
    desc = json['desc'];
    content = json['content'];
    status = json['status'];
    addtime = json['addtime'];
    thumUrl = json['thum_url'];
    user = json['user'];
    userType = json['user_type'];
    sorts = json['sorts'];
    isSj = json['is_sj'];
    examine = json['examine'];
    issue = json['issue'];
    studyStatus = json['study_status'];
    thumbUrl = json['thumb_url'];
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
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['content'] = this.content;
    data['status'] = this.status;
    data['addtime'] = this.addtime;
    data['thum_url'] = this.thumUrl;
    data['user'] = this.user;
    data['user_type'] = this.userType;
    data['sorts'] = this.sorts;
    data['is_sj'] = this.isSj;
    data['examine'] = this.examine;
    data['issue'] = this.issue;
    data['study_status'] = this.studyStatus;
    data['thumb_url'] = this.thumbUrl;
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

  ///分类id
  int pid;

  ///部门id
  int dId;

  ///章节名称
  String name;

  ///添加时间
  int addtime;

  Chapter({this.id, this.pid, this.dId, this.name, this.addtime});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    dId = json['d_id'];
    name = json['name'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['d_id'] = this.dId;
    data['name'] = this.name;
    data['addtime'] = this.addtime;
    return data;
  }
}
