class BannerDataType {
  int id;
  String name;
  int position;
  int typeLink;
  String link;
  String thumbUrl;
  int addtime;
  int status;
  String sorts;
  String linkName;
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
