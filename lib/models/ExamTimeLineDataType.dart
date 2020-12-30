///考试时间线数据类型
class ExamTimeLineDataType {
  int time;
  List<TimeLineChildren> child;

  ExamTimeLineDataType({this.time, this.child});

  ExamTimeLineDataType.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['child'] != null) {
      child = new List<TimeLineChildren>();
      json['child'].forEach((v) {
        child.add(new TimeLineChildren.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    if (this.child != null) {
      data['child'] = this.child.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeLineChildren {
  int id;
  int dId;
  int mid;
  int pid;
  int mTestId;
  int classId;
  int paperId;
  String name;
  String address;
  String startTime;
  String endTime;
  String minDuration;
  String duration;
  String passingMark;
  int testNumType;
  int testNum;
  int cutScreenType;
  int cutScreenNum;
  int cutScreenTime;
  String user;
  int userType;
  int type;
  int isIntegral;
  int integral;
  int integralType;
  Null scoreRule;
  String sorts;
  int status;
  int addtime;

  TimeLineChildren(
      {this.id,
      this.dId,
      this.mid,
      this.pid,
      this.mTestId,
      this.classId,
      this.paperId,
      this.name,
      this.address,
      this.startTime,
      this.endTime,
      this.minDuration,
      this.duration,
      this.passingMark,
      this.testNumType,
      this.testNum,
      this.cutScreenType,
      this.cutScreenNum,
      this.cutScreenTime,
      this.user,
      this.userType,
      this.type,
      this.isIntegral,
      this.integral,
      this.integralType,
      this.scoreRule,
      this.sorts,
      this.status,
      this.addtime});

  TimeLineChildren.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dId = json['d_id'];
    mid = json['mid'];
    pid = json['pid'];
    mTestId = json['m_test_id'];
    classId = json['class_id'];
    paperId = json['paper_id'];
    name = json['name'];
    address = json['address'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    minDuration = json['min_duration'];
    duration = json['duration'];
    passingMark = json['passing_mark'];
    testNumType = json['test_num_type'];
    testNum = json['test_num'];
    cutScreenType = json['cut_screen_type'];
    cutScreenNum = json['cut_screen_num'];
    cutScreenTime = json['cut_screen_time'];
    user = json['user'];
    userType = json['user_type'];
    type = json['type'];
    isIntegral = json['is_integral'];
    integral = json['integral'];
    integralType = json['integral_type'];
    scoreRule = json['score_rule'];
    sorts = json['sorts'];
    status = json['status'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['d_id'] = this.dId;
    data['mid'] = this.mid;
    data['pid'] = this.pid;
    data['m_test_id'] = this.mTestId;
    data['class_id'] = this.classId;
    data['paper_id'] = this.paperId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['min_duration'] = this.minDuration;
    data['duration'] = this.duration;
    data['passing_mark'] = this.passingMark;
    data['test_num_type'] = this.testNumType;
    data['test_num'] = this.testNum;
    data['cut_screen_type'] = this.cutScreenType;
    data['cut_screen_num'] = this.cutScreenNum;
    data['cut_screen_time'] = this.cutScreenTime;
    data['user'] = this.user;
    data['user_type'] = this.userType;
    data['type'] = this.type;
    data['is_integral'] = this.isIntegral;
    data['integral'] = this.integral;
    data['integral_type'] = this.integralType;
    data['score_rule'] = this.scoreRule;
    data['sorts'] = this.sorts;
    data['status'] = this.status;
    data['addtime'] = this.addtime;
    return data;
  }
}
