// 考试列表项数据类型

class ExamListDataType {
  ///列表项id
  int id;

  ///分类id
  int pid;

  ///补考id
  int mTestId;

  ///班级id
  int classId;

  ///试卷id
  int paperId;

  ///考试标题
  String name;

  ///考试地址
  String address;

  ///开始时间
  int startTime;

  ///结束时间
  int endTime;

  ///考试时长
  int duration;

  ///及格分数
  int passingMark;

  /// 考试次数  0无限
  int testNum;

  ///是否开启切屏  0未开启  1开启
  int cutScreenType;

  ///切屏次数
  int cutScreenNum;

  ///切屏时间
  int cutScreenTime;

  /// 1模拟考试  2正式考试  3补考
  int type;

  ///是否可以考试
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
