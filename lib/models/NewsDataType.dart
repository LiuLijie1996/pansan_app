class NewsDataType {
  ///新闻id
  int id;

  ///导航id
  int pid;

  ///标题
  String title;

  ///简介
  String desc;

  ///封面
  String thumbUrl;

  ///多图新闻
  List<String> imgList;

  ///新闻类型 1图文  2视频
  int type;

  ///资源id
  int materiaId;

  ///文章内容
  String content;

  ///文章纯文本
  String newsContent;

  ///是否推荐 0不推荐 1推荐
  int tuij;

  ///新闻添加时间
  int addtime;

  ///观看次数
  int viewNum;

  ///点赞个数
  int upvote;

  ///视频链接
  Object materia;

  ///阅读图文有效时间：1000字60秒
  int newsImgText;

  ///视频有效观看时间 单位：秒
  int newsVideo;

  ///是否收藏
  bool collect;

  NewsDataType(
      {this.id,
      this.pid,
      this.title,
      this.desc,
      this.thumbUrl,
      this.imgList,
      this.type,
      this.materiaId,
      this.content,
      this.tuij,
      this.addtime,
      this.viewNum,
      this.upvote,
      this.materia,
      this.newsImgText,
      this.newsVideo,
      this.newsContent,
      this.collect});

  NewsDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    title = json['title'];
    desc = json['desc'];
    thumbUrl = json['thumb_url'];
    imgList = json['img_list'];
    type = json['type'];
    materiaId = json['materia_id'];
    content = json['content'];
    tuij = json['tuij'];
    addtime = json['addtime'];
    viewNum = json['view_num'];
    upvote = json['upvote'];
    materia = json['materia'];
    newsImgText = json['newsImgText'];
    newsVideo = json['newsVideo'];
    collect = json['collect'];
    newsContent = json['news_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['thumb_url'] = this.thumbUrl;
    data['img_list'] = this.imgList;
    data['type'] = this.type;
    data['materia_id'] = this.materiaId;
    data['content'] = this.content;
    data['tuij'] = this.tuij;
    data['addtime'] = this.addtime;
    data['view_num'] = this.viewNum;
    data['upvote'] = this.upvote;
    data['materia'] = this.materia;
    data['newsImgText'] = this.newsImgText;
    data['newsVideo'] = this.newsVideo;
    data['collect'] = this.collect;
    data['news_content'] = this.newsContent;
    return data;
  }
}
