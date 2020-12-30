/// 导航数据类型
class NavDataType {
  ///导航id
  int id;

  ///部门id
  int dId;

  ///父级导航id
  int pid;

  ///导航标题
  String name;

  ///子导航
  List<Children> children;

  ///数据列表
  List data;

  ///分页
  int page;

  ///数据总条数
  int total;

  ///导航图片
  String icon;

  NavDataType({
    this.id,
    this.dId,
    this.pid,
    this.name,
    this.children,
    this.data,
    this.page,
    this.total,
    this.icon,
  });

  NavDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    name = json['name'];
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
      });
    }
    data = json['data'];
    page = json['page'];
    total = json['total'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['name'] = this.name;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    data['data'] = this.data;
    data['page'] = this.page;
    data['total'] = this.total;
    data['icon'] = this.icon;
    return data;
  }
}

class Children {
  ///导航id
  int id;

  ///部门id
  int dId;

  ///父级导航id
  int pid;

  ///导航标题
  String name;

  Children({this.id, this.dId, this.pid, this.name});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    pid = json['pid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['pid'] = this.pid;
    data['name'] = this.name;
    return data;
  }
}
