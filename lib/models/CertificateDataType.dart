class CertificateDataType {
  int id;
  String idCard;
  String name;
  String dep;
  int addtime;

  CertificateDataType(
      {this.id, this.idCard, this.name, this.dep, this.addtime});

  CertificateDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCard = json['idCard'];
    name = json['name'];
    dep = json['dep'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCard'] = this.idCard;
    data['name'] = this.name;
    data['dep'] = this.dep;
    data['addtime'] = this.addtime;
    return data;
  }
}
