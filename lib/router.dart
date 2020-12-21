import 'package:flutter/material.dart';
import 'package:pansan_app/pages/answerSheet.dart';
import 'package:pansan_app/pages/examDetails.dart';
import 'package:pansan_app/pages/examOver.dart';
import 'package:pansan_app/pages/exerciseDetails.dart';
import 'package:pansan_app/pages/exerciseSpecialtyDetails.dart';
import 'package:pansan_app/pages/exerciseSpecialtySelect.dart';
import 'package:pansan_app/pages/exerciseSelect.dart';
import 'package:pansan_app/pages/addAdvisory.dart';
import 'package:pansan_app/pages/examSelect.dart';
import 'package:pansan_app/pages/examSiteInfo.dart';
import 'package:pansan_app/pages/questionsCorrection.dart';
import 'package:pansan_app/pages/searchCourseList.dart';
import 'package:pansan_app/pages/dayTopic.dart';
import 'package:pansan_app/pages/informAffiche.dart';
import 'package:pansan_app/pages/myAdvisory.dart';
import 'package:pansan_app/pages/myCollect.dart';
import 'package:pansan_app/pages/myCourse.dart';
import 'package:pansan_app/pages/myGrade.dart';
import 'package:pansan_app/pages/myInformation.dart';
import 'package:pansan_app/pages/myMistakes.dart';
import 'package:pansan_app/pages/testRecords.dart';
import 'package:pansan_app/tabbarPages/MyBottomNavigationBar.dart';
import 'package:pansan_app/pages/staffServe.dart';
import 'package:pansan_app/pages/login.dart';
import 'package:pansan_app/pages/settings.dart';
import 'package:pansan_app/pages/integralCentre.dart';
import 'package:pansan_app/pages/updatePwd.dart';
import 'package:pansan_app/tabbarPages/startPage.dart';
import 'package:pansan_app/pages/exerciseOver.dart';
import 'package:pansan_app/pages/examResultAnalyse.dart';
import 'package:pansan_app/pages/NewsDetail.dart';

Map<String, Function> routers = {
  "/": (context) => StartPage(), //启动页
  "/home": (context) => MyBottomNavigationBar(),
  "/integralCentre": (context) => IntegralCentre(),
  "/settings": (context) => Settings(), //设置页面
  "/login": (context) => Login(), //登录页面
  "/updatePwd": (context) => UpdatePwd(), //修改密码页面
  "/staffServe": (context) => StaffServe(), //职工服务
  "/informAffiche": (context) => InformAffiche(), //通知公告
  "/dayTopic": (context) => DayTopic(), //一日一题
  "/myInformation": (context) => MyInformation(), //我的资料
  "/myCourse": (context) => MyCourse(), //我的课程
  "/myMistakes": (context) => MyMistakes(), //我的错题
  "/myCollect": (context) => MyCollect(), //我的收藏
  "/testRecords": (context) => TestRecords(), //考试记录
  "/myGrade": (context) => MyGrade(), //我的班级
  "/myAdvisory": (context) => MyAdvisory(), //我的咨询
  "/addAdvisory": (context) => AddAdvisory(), //添加咨询

  //课程列表
  "/courseList": (context, {arguments}) {
    return SearchCourseList(arguments: arguments);
  },
  //考场信息页面
  "/examSiteInfo": (context, {arguments}) {
    return ExamSiteInfo(arguments: arguments);
  },
  //考试列表选择
  "/examSelect": (context, {arguments}) {
    return ExamSelect(arguments: arguments);
  },
  //练习列表选择
  "/exerciseSelect": (context, {arguments}) {
    return ExerciseSelect(arguments: arguments);
  },
  //专项练习列表选择
  "/exerciseSpecialtySelect": (context, {arguments}) {
    return ExerciseSpecialtySelect(arguments: arguments);
  },
  //练习详情
  "/exerciseDetails": (context, {arguments}) {
    return ExerciseDetails(arguments: arguments);
  },
  // 练习结束页
  "/exerciseOver": (context, {arguments}) {
    return ExerciseOver(
      dataList: arguments['dataList'],
      expend_time: arguments['expend_time'],
    );
  },
  // 考试结果分析
  "/examResultAnalyse": (context, {arguments}) {
    return ExamResultAnalyse(
      dataList: arguments['dataList'],
    );
  },
  // 题目纠错
  "/questionsCorrection": (context, {arguments}) {
    return QuestionsCorrection(
      issueData: arguments['issueData'],
    );
  },
  // 题目纠错
  "/exerciseSpecialtyDetails": (context, {arguments}) {
    return ExerciseSpecialtyDetails(
      arguments: arguments,
    );
  },
  // 答题卡
  "/answerSheet": (context, {arguments}) {
    return AnswerSheet(
      dataList: arguments['dataList'],
      reminder: arguments['reminder'] == null ? true : arguments['reminder'],
    );
  },
  // 考试详情
  "/examDetails": (context, {arguments}) {
    return ExamDetails(
      examSiteInfo: arguments['examSiteInfo'],
    );
  },
  // 考试结束页
  "/examOver": (context, {arguments}) {
    return ExamOver(
      dataList: arguments['dataList'],
      examSiteInfo: arguments['examSiteInfo'],
      expend_time: arguments['expend_time'],
    );
  },
  // 新闻详情页
  "/newsDetail": (context, {arguments}) {
    return NewsDetail(
      arguments: arguments,
    );
  },
};

Function onGenerateRoute = (RouteSettings settings) {
  String routerName = settings.name; //获取路由名称
  Function routerPage = routers[routerName]; //获取路由对应的组件

  if (routerPage != null) {
    if (settings.arguments != null) {
      return MaterialPageRoute(
        builder: (context) {
          return routerPage(context, arguments: settings.arguments);
        },
      );
    }

    return MaterialPageRoute(
      builder: (context) {
        return routerPage(context);
      },
    );
  } else {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("页面不存在"),
          ),
        );
      },
    );
  }
};
