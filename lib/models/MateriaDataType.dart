// 视频的数据类型
class MateriaDataType {
  int id;
  String name;
  int type;

  ///播放链接
  String link;
  String key;
  String fileId;

  ///总时长
  num duration;
  String size;
  String thumbUrl;
  String sorts;
  int addtime;

  MateriaDataType(
      {this.id,
      this.name,
      this.type,
      this.link,
      this.key,
      this.fileId,
      this.duration,
      this.size,
      this.thumbUrl,
      this.sorts,
      this.addtime});

  MateriaDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    link = json['link'];
    key = json['key'];
    fileId = json['fileId'];
    duration = json['duration'];
    size = json['size'];
    thumbUrl = json['thumb_url'];
    sorts = json['sorts'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['link'] = this.link;
    data['key'] = this.key;
    data['fileId'] = this.fileId;
    data['duration'] = this.duration;
    data['size'] = this.size;
    data['thumb_url'] = this.thumbUrl;
    data['sorts'] = this.sorts;
    data['addtime'] = this.addtime;
    return data;
  }
}
