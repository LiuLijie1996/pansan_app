// 导航数据类型

class NavDataType {
  int id;
  int dId;
  int pid;
  String name;
  List<Children> children;
  List data;
  int page;
  int total;

  NavDataType(
      {this.id,
      this.dId,
      this.pid,
      this.name,
      this.children,
      this.data,
      this.page,
      this.total});

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
    return data;
  }
}

class Children {
  int id;
  int dId;
  int pid;
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
