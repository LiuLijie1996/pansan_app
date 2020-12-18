// 考试列表项数据类型

class ExamListDataType {
  int id;
  int pid;
  int mTestId;
  int classId;
  int paperId;
  String name;
  String address;
  int startTime;
  int endTime;
  int duration;
  int passingMark;
  int testNum;
  int cutScreenType;
  int cutScreenNum;
  int cutScreenTime;
  int type;
  bool isTest;
  int status;

  ExamListDataType(
      {this.id,
      this.pid,
      this.mTestId,
      this.classId,
      this.paperId,
      this.name,
      this.address,
      this.startTime,
      this.endTime,
      this.duration,
      this.passingMark,
      this.testNum,
      this.cutScreenType,
      this.cutScreenNum,
      this.cutScreenTime,
      this.type,
      this.isTest});

  ExamListDataType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    mTestId = json['m_test_id'];
    classId = json['class_id'];
    paperId = json['paper_id'];
    name = json['name'];
    address = json['address'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    passingMark = json['passing_mark'];
    testNum = json['test_num'];
    cutScreenType = json['cut_screen_type'];
    cutScreenNum = json['cut_screen_num'];
    cutScreenTime = json['cut_screen_time'];
    type = json['type'];
    isTest = json['is_test'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['m_test_id'] = this.mTestId;
    data['class_id'] = this.classId;
    data['paper_id'] = this.paperId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['passing_mark'] = this.passingMark;
    data['test_num'] = this.testNum;
    data['cut_screen_type'] = this.cutScreenType;
    data['cut_screen_num'] = this.cutScreenNum;
    data['cut_screen_time'] = this.cutScreenTime;
    data['type'] = this.type;
    data['is_test'] = this.isTest;
    data['status'] = this.status;
    return data;
  }
}
