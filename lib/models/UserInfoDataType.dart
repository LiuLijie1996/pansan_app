///用户信息数据类型
class UserInfoDataType {
  ///用户id
  int id;

  ///部门id
  int pid;

  ///用户姓名
  String name;

  ///用户密码
  String password;

  ///头像
  String headUrl;

  ///性别 1男  2女
  int sex;

  ///生日
  int birthday;

  ///身份证
  String idCard;

  ///职工编号
  String no;

  ///手机号
  String phone;

  ///部门
  String department;

  ///学历
  String education;

  ///职称
  String title;

  ///职务
  String job;

  ///工种
  String typeWork;

  ///政治面貌
  String politicsStatus;

  ///入党时间
  String partyTime;

  ///籍贯
  String native;

  ///添加时间
  int addtime;

  ///1正常  2删除
  int status;

  ///token
  String token;

  ///token到期时间
  int expireTime;

  ///个推id
  String cid;

  ///参加工作时间
  int jobtime;

  ///岗位工种
  String jobWork;

  ///技能
  String skillLevel;

  ///是否绑定手机   1已绑定  2未绑定
  int bindPhone;

  UserInfoDataType(
      {this.id,
      this.pid,
      this.name,
      this.password,
      this.headUrl,
      this.sex,
      this.birthday,
      this.idCard,
      this.no,
      this.phone,
      this.department,
      this.education,
      this.title,
      this.job,
      this.typeWork,
      this.politicsStatus,
      this.partyTime,
      this.native,
      this.addtime,
      this.status,
      this.token,
      this.expireTime,
      this.cid,
      this.jobtime,
      this.jobWork,
      this.skillLevel,
      this.bindPhone});

  UserInfoDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    name = json['name'];
    password = json['password'];
    headUrl = json['headUrl'];
    sex = json['sex'];
    birthday = json['birthday'];
    idCard = json['idCard'];
    no = json['No'];
    phone = json['phone'];
    department = json['department'];
    education = json['education'];
    title = json['title'];
    job = json['job'];
    typeWork = json['type_work'];
    politicsStatus = json['politics_status'];
    partyTime = json['party_time'];
    native = json['native'];
    addtime = json['addtime'];
    status = json['status'];
    token = json['token'];
    expireTime = json['expire_time'];
    cid = json['cid'];
    jobtime = json['jobtime'];
    jobWork = json['job_work'];
    skillLevel = json['skill_level'];
    bindPhone = json['bindPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['name'] = this.name;
    data['password'] = this.password;
    data['headUrl'] = this.headUrl;
    data['sex'] = this.sex;
    data['birthday'] = this.birthday;
    data['idCard'] = this.idCard;
    data['No'] = this.no;
    data['phone'] = this.phone;
    data['department'] = this.department;
    data['education'] = this.education;
    data['title'] = this.title;
    data['job'] = this.job;
    data['type_work'] = this.typeWork;
    data['politics_status'] = this.politicsStatus;
    data['party_time'] = this.partyTime;
    data['native'] = this.native;
    data['addtime'] = this.addtime;
    data['status'] = this.status;
    data['token'] = this.token;
    data['expire_time'] = this.expireTime;
    data['cid'] = this.cid;
    data['jobtime'] = this.jobtime;
    data['job_work'] = this.jobWork;
    data['skill_level'] = this.skillLevel;
    data['bindPhone'] = this.bindPhone;
    return data;
  }
}
