///咨询类型
class AdvisoryDataType {
  /// 咨询 id
  int id;

  /// 咨询 pid
  int pid;

  /// 用户id
  int userId;

  /// 咨询标题
  String title;

  /// 咨询内容
  String content;
  String link;
  String key;
  int addtime;
  int status;
  int audit;
  int transferId;
  List<Reply> reply;

  AdvisoryDataType(
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
      this.transferId,
      this.reply});

  AdvisoryDataType.fromJson(Map<String, dynamic> json) {
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
    if (json['reply'] != null) {
      reply = new List<Reply>();
      json['reply'].forEach((v) {
        reply.add(new Reply.fromJson(v));
      });
    }
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
    if (this.reply != null) {
      data['reply'] = this.reply.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reply {
  int id;
  int pid;
  String content;
  int addtime;

  Reply({this.id, this.pid, this.content, this.addtime});

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    content = json['content'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['content'] = this.content;
    data['addtime'] = this.addtime;
    return data;
  }
}
