///证书详情数据类型
class CertificateDetailDataType {
  int id;
  int pid;
  String dep;
  String name;
  String certName;
  String certNo;
  String idCard;
  String time;
  String majorType;
  String majorLevel;
  String techLevel;
  String validStartTime;
  String validEndTime;
  String reexamineTime;
  String mechanism;
  String idPhoto1;
  String idPhoto2;
  int addtime;
  int status;
  String time2;

  CertificateDetailDataType(
      {this.id,
      this.pid,
      this.dep,
      this.name,
      this.certName,
      this.certNo,
      this.idCard,
      this.time,
      this.majorType,
      this.majorLevel,
      this.techLevel,
      this.validStartTime,
      this.validEndTime,
      this.reexamineTime,
      this.mechanism,
      this.idPhoto1,
      this.idPhoto2,
      this.addtime,
      this.status,
      this.time2});

  CertificateDetailDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    dep = json['dep'];
    name = json['name'];
    certName = json['cert_name'];
    certNo = json['cert_no'];
    idCard = json['idCard'];
    time = json['time'];
    majorType = json['major_type'];
    majorLevel = json['major_level'];
    techLevel = json['tech_level'];
    validStartTime = json['valid_start_time'];
    validEndTime = json['valid_end_time'];
    reexamineTime = json['reexamine_time'];
    mechanism = json['mechanism'];
    idPhoto1 = json['id_photo_1'];
    idPhoto2 = json['id_photo_2'];
    addtime = json['addtime'];
    status = json['status'];
    time2 = json['time2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['dep'] = this.dep;
    data['name'] = this.name;
    data['cert_name'] = this.certName;
    data['cert_no'] = this.certNo;
    data['idCard'] = this.idCard;
    data['time'] = this.time;
    data['major_type'] = this.majorType;
    data['major_level'] = this.majorLevel;
    data['tech_level'] = this.techLevel;
    data['valid_start_time'] = this.validStartTime;
    data['valid_end_time'] = this.validEndTime;
    data['reexamine_time'] = this.reexamineTime;
    data['mechanism'] = this.mechanism;
    data['id_photo_1'] = this.idPhoto1;
    data['id_photo_2'] = this.idPhoto2;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['time2'] = this.time2;
    return data;
  }
}
