class NewsDataType {
  int id; //新闻id
  int pid; //导航id
  String title; //标题
  String desc; //简介
  String thumbUrl; //封面
  int type; //新闻类型 1图文  2视频
  int materiaId; //资源id
  String content; //文章内容
  int tuij; //是否推荐 0不推荐 1推荐
  int addtime; //新闻添加时间
  int viewNum; //观看次数
  Object materia; //视频链接
  int newsImgText; //阅读图文有效时间：1000字60秒
  int newsVideo; //视频有效观看时间 单位：秒
  bool collect; //是否收藏

  NewsDataType(
      {this.id,
      this.pid,
      this.title,
      this.desc,
      this.thumbUrl,
      this.type,
      this.materiaId,
      this.content,
      this.tuij,
      this.addtime,
      this.viewNum,
      this.materia,
      this.newsImgText,
      this.newsVideo,
      this.collect});

  NewsDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    title = json['title'];
    desc = json['desc'];
    thumbUrl = json['thumb_url'];
    type = json['type'];
    materiaId = json['materia_id'];
    content = json['content'];
    tuij = json['tuij'];
    addtime = json['addtime'];
    viewNum = json['view_num'];
    materia = json['materia'];
    newsImgText = json['newsImgText'];
    newsVideo = json['newsVideo'];
    collect = json['collect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['thumb_url'] = this.thumbUrl;
    data['type'] = this.type;
    data['materia_id'] = this.materiaId;
    data['content'] = this.content;
    data['tuij'] = this.tuij;
    data['addtime'] = this.addtime;
    data['view_num'] = this.viewNum;
    data['materia'] = this.materia;
    data['newsImgText'] = this.newsImgText;
    data['newsVideo'] = this.newsVideo;
    data['collect'] = this.collect;
    return data;
  }
}
