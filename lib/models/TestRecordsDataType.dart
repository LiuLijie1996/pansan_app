// 考试记录数据类型

import './ExamListDataType.dart'; // 考试列表项数据类型

class TestRecordsDataType {
  int id;
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
  ExamListDataType test;

  TestRecordsDataType({
    this.id,
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
    this.test,
  });

  TestRecordsDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    if (json['test'] != null) {
      test = ExamListDataType.fromJson(json['test']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    if (this.test != null) {
      data['test'] = this.test.toJson();
    }
    return data;
  }
}
