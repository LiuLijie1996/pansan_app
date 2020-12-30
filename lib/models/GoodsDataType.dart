///商品数据类型
class GoodsDataType {
  int id;
  String name;
  String thumbUrl;
  int score;
  int num;
  int addtime;
  int status;
  int exchange;

  GoodsDataType(
      {this.id,
      this.name,
      this.thumbUrl,
      this.score,
      this.num,
      this.addtime,
      this.status,
      this.exchange});

  GoodsDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbUrl = json['thumb_url'];
    score = json['score'];
    num = json['num'];
    addtime = json['addtime'];
    status = json['status'];
    exchange = json['exchange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumb_url'] = this.thumbUrl;
    data['score'] = this.score;
    data['num'] = this.num;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['exchange'] = this.exchange;
    return data;
  }
}
