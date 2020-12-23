import './MateriaDataType.dart';

// 章节数据类型

class CourseChapterDataType {
  int id;
  int dId;
  int pid;
  int mid;
  String name;
  int addtime;
  String sorts;
  int status;
  int isSj;
  int examine;
  int issue;
  List<ChapterChildren> children;

  CourseChapterDataType(
      {this.id,
      this.dId,
      this.pid,
      this.mid,
      this.name,
      this.addtime,
      this.sorts,
      this.status,
      this.isSj,
      this.examine,
      this.issue,
      this.children});

  CourseChapterDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    mid = json['mid'];
    name = json['name'];
    addtime = json['addtime'];
    sorts = json['sorts'];
    status = json['status'];
    isSj = json['is_sj'];
    examine = json['examine'];
    issue = json['issue'];
    if (json['children'] != null) {
      children = new List<ChapterChildren>();
      json['children'].forEach((v) {
        children.add(new ChapterChildren.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['addtime'] = this.addtime;
    data['sorts'] = this.sorts;
    data['status'] = this.status;
    data['is_sj'] = this.isSj;
    data['examine'] = this.examine;
    data['issue'] = this.issue;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChapterChildren {
  int id;
  int dId;
  int pid;
  int materiaId;
  int courseId;
  String name;
  String desc;

  ///1音频  2视频  3图文  4文件
  int type;
  String thumbUrl;
  String link;
  String content;
  int isSj;
  int addtime;
  String sorts;

  ///学习状态 1已学完  2未学习  3学习中
  int status;
  int issue;
  MateriaDataType materia;
  num duration;

  ///文档有效预览时间
  num stuDoc;

  ///图文有效预览时间
  num stuImgText;

  ChapterChildren({
    this.id,
    this.dId,
    this.pid,
    this.materiaId,
    this.courseId,
    this.name,
    this.desc,
    this.type,
    this.thumbUrl,
    this.link,
    this.content,
    this.isSj,
    this.addtime,
    this.sorts,
    this.status,
    this.issue,
    this.materia,
    this.duration,
    this.stuDoc,
    this.stuImgText,
  });

  ChapterChildren.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    materiaId = json['materia_id'];
    courseId = json['course_id'];
    name = json['name'];
    desc = json['desc'];
    type = json['type'];
    thumbUrl = json['thumb_url'];
    link = json['link'];
    content = json['content'];
    isSj = json['is_sj'];
    addtime = json['addtime'];
    sorts = json['sorts'];
    status = json['status'];
    issue = json['issue'];
    materia = json['materia'] != null
        ? new MateriaDataType.fromJson(json['materia'])
        : null;
    duration = json['duration'];
    stuDoc = json['stuDoc'];
    stuImgText = json['stuImgText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['materia_id'] = this.materiaId;
    data['course_id'] = this.courseId;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['type'] = this.type;
    data['thumb_url'] = this.thumbUrl;
    data['link'] = this.link;
    data['content'] = this.content;
    data['is_sj'] = this.isSj;
    data['addtime'] = this.addtime;
    data['sorts'] = this.sorts;
    data['status'] = this.status;
    data['issue'] = this.issue;
    if (this.materia != null) {
      data['materia'] = this.materia.toJson();
    }
    data['duration'] = this.duration;
    data['stuDoc'] = this.stuDoc;
    data['stuImgText'] = this.stuImgText;
    return data;
  }
}
