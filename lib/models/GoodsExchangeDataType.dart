import 'package:pansan_app/models/GoodsDataType.dart';

class GoodsExchangeDataType {
  int id;
  int dId;
  int userId;
  int goodsId;
  int score;
  int addtime;

  /// 1已审核  2审核中
  int status;
  int updateTime;
  GoodsDataType goods;

  GoodsExchangeDataType(
      {this.id,
      this.dId,
      this.userId,
      this.goodsId,
      this.score,
      this.addtime,
      this.status,
      this.updateTime,
      this.goods});

  GoodsExchangeDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    userId = json['user_id'];
    goodsId = json['goods_id'];
    score = json['score'];
    addtime = json['addtime'];
    status = json['status'];
    updateTime = json['update_time'];
    goods = json['goods'] != null
        ? new GoodsDataType.fromJson(json['goods'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['user_id'] = this.userId;
    data['goods_id'] = this.goodsId;
    data['score'] = this.score;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['update_time'] = this.updateTime;
    if (this.goods != null) {
      data['goods'] = this.goods.toJson();
    }
    return data;
  }
}
