/// 三违情况数据类型
class IllegalManageDataType {
  int id;
  int pid;
  int userId;
  String title;
  String content;
  String link;
  String key;
  int addtime;
  int status;
  int audit;
  int transferId;

  IllegalManageDataType(
      {this.id,
      this.pid,
      this.userId,
      this.title,
      this.content,
      this.link,
      this.key,
      this.addtime,
      this.status,
      this.audit,
      this.transferId});

  IllegalManageDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    link = json['link'];
    key = json['key'];
    addtime = json['addtime'];
    status = json['status'];
    audit = json['audit'];
    transferId = json['transfer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['link'] = this.link;
    data['key'] = this.key;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['audit'] = this.audit;
    data['transfer_id'] = this.transferId;
    return data;
  }
}
