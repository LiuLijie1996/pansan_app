/// 考试排行数据类型
class ExamRankingDataType {
  int id;
  int rank;
  int testId;
  int userId;
  int departmentId;
  int mTestId;
  int type;
  int fraction;
  int testTime;
  int addtime;
  int sorts;
  int updateTime;
  int testType;
  String option;
  String qGroup;
  int testNum;
  User user;

  ExamRankingDataType(
      {this.id,
      this.rank,
      this.testId,
      this.userId,
      this.departmentId,
      this.mTestId,
      this.type,
      this.fraction,
      this.testTime,
      this.addtime,
      this.sorts,
      this.updateTime,
      this.testType,
      this.option,
      this.qGroup,
      this.testNum,
      this.user});

  ExamRankingDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rank = json['rank'];
    testId = json['test_id'];
    userId = json['user_id'];
    departmentId = json['department_id'];
    mTestId = json['m_test_id'];
    type = json['type'];
    fraction = json['fraction'];
    testTime = json['test_time'];
    addtime = json['addtime'];
    sorts = json['sorts'];
    updateTime = json['update_time'];
    testType = json['test_type'];
    option = json['option'];
    qGroup = json['q_group'];
    testNum = json['test_num'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rank'] = this.rank;
    data['test_id'] = this.testId;
    data['user_id'] = this.userId;
    data['department_id'] = this.departmentId;
    data['m_test_id'] = this.mTestId;
    data['type'] = this.type;
    data['fraction'] = this.fraction;
    data['test_time'] = this.testTime;
    data['addtime'] = this.addtime;
    data['sorts'] = this.sorts;
    data['update_time'] = this.updateTime;
    data['test_type'] = this.testType;
    data['option'] = this.option;
    data['q_group'] = this.qGroup;
    data['test_num'] = this.testNum;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String headUrl;
  Department department;

  User({this.id, this.name, this.department});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    headUrl = json['headUrl'];
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['headUrl'] = this.headUrl;
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }
    return data;
  }
}

class Department {
  int id;
  String name;
  int pid;

  Department({this.id, this.name, this.pid});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pid = json['pid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pid'] = this.pid;
    return data;
  }
}
