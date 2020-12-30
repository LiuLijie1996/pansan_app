///消息通知数据类型
class UserMessageDataType {
  int id;
  String name;
  String content;
  int userType;
  int addtime;
  String user;
  String dId;

  ///1已读  2未读
  int status;

  ///1群发通知，2咨询通知
  int type;

  ///咨询详情id
  int linkId;

  ///附件地址（文件）
  String annex;

  ///附件名称
  String annexName;

  ///
  String link;

  UserMessageDataType({
    this.id,
    this.name,
    this.content,
    this.userType,
    this.addtime,
    this.user,
    this.dId,
    this.status,
    this.type,
    this.linkId,
    this.annex,
    this.link,
    this.annexName,
  });

  UserMessageDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    content = json['content'];
    userType = json['user_type'];
    addtime = json['addtime'];
    user = json['user'];
    dId = json['d_id'];
    status = json['status'];
    type = json['type'];
    linkId = json['link_id'];
    annex = json['annex'];
    link = json['link'];
    annexName = json['annex_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['content'] = this.content;
    data['user_type'] = this.userType;
    data['addtime'] = this.addtime;
    data['user'] = this.user;
    data['d_id'] = this.dId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['link_id'] = this.linkId;
    data['annex'] = this.annex;
    data['link'] = this.link;
    data['annex_name'] = this.annexName;
    return data;
  }
}
