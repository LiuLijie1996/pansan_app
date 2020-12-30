///轮播图数据类型
class BannerDataType {
  ///banner的id
  int id;

  ///banner标题
  String name;
  int position;

  ///链接类型 0不跳转  1考试分类  3练习分类  2课程列表  4考试列表  5新闻详情
  int typeLink;

  ///分类id 或 列表id
  String link;

  ///封面图
  String thumbUrl;

  ///添加时间
  int addtime;
  int status;
  String sorts;
  String linkName;

  ///新闻类型 1图文  2视频
  int newsType;

  BannerDataType(
      {this.id,
      this.name,
      this.position,
      this.typeLink,
      this.link,
      this.thumbUrl,
      this.addtime,
      this.status,
      this.sorts,
      this.linkName,
      this.newsType});

  BannerDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    typeLink = json['type_link'];
    link = json['link'];
    thumbUrl = json['thumb_url'];
    addtime = json['addtime'];
    status = json['status'];
    sorts = json['sorts'];
    linkName = json['link_name'];
    newsType = json['news_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['type_link'] = this.typeLink;
    data['link'] = this.link;
    data['thumb_url'] = this.thumbUrl;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['sorts'] = this.sorts;
    data['link_name'] = this.linkName;
    data['news_type'] = this.newsType;
    return data;
  }
}
