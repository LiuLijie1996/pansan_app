import 'package:flutter/material.dart';
import './pages/coursePlan.dart';
import './pages/integralRule.dart';
import './pages/answerSheet.dart';
import './pages/examDetails.dart';
import './pages/examOver.dart';
import './pages/exerciseDetails.dart';
import './pages/exerciseSpecialtyDetails.dart';
import './pages/exerciseSpecialtySelect.dart';
import './pages/exerciseSelect.dart';
import './pages/addAdvisory.dart';
import './pages/examSelect.dart';
import './pages/examSiteInfo.dart';
import './pages/questionsCorrection.dart';
import './pages/searchCourseList.dart';
import './pages/dayTopic.dart';
import './pages/informAffiche.dart';
import './pages/myAdvisory.dart';
import './pages/myCollect.dart';
import './pages/myCourse.dart';
import './pages/myGrade.dart';
import './pages/myInformation.dart';
import './pages/myMistakes.dart';
import './pages/testRecords.dart';
import './tabbarPages/MyBottomNavigationBar.dart';
import './pages/staffServe.dart';
import './pages/login.dart';
import './pages/settings.dart';
import './pages/integralCentre.dart';
import './pages/updatePwd.dart';
import './tabbarPages/startPage.dart';
import './pages/exerciseOver.dart';
import './pages/examResultAnalyse.dart';
import './pages/newsDetail.dart';
import './pages/courseDetail.dart';
import './pages/searchPage.dart';
import './pages/AdvisoryDetail.dart';
import './pages/integralDetail.dart';
import './pages/exchangeRecord.dart';
import './pages/checkingInRecord.dart';
import './pages/ExamRanking.dart';
import './pages/QuestionsCollect.dart';
import './pages/DayTopicDetail.dart';
import './pages/CertificateDetail.dart';
import './pages/AfficheDetail.dart';

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
  "/searchPage": (context) => SearchPage(), //搜索页
  "/exchangeRecord": (context) => ExchangeRecord(), //兑换记录
  "/integralRule": (context) => IntegralRule(), //积分规则
  "/examRanking": (context) => ExamRanking(), //积分规则
  "/questionsCollect": (context) => QuestionsCollect(), //试题收藏页面

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
      exerciseSelectItem: arguments['exerciseSelectItem'],
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
  // 课程详情页
  "/courseDetail": (context, {arguments}) {
    return CourseDetail(
      arguments: arguments,
    );
  },
  // 我的（职工）咨询详情页
  "/advisoryDetail": (context, {arguments}) {
    return AdvisoryDetail(
      arguments: arguments,
    );
  },
  // 积分明细
  "/integralDetail": (context, {arguments}) {
    return IntegralDetail();
  },

  //考勤记录
  "/checkingInRecord": (context, {arguments}) {
    return CheckingInRecord(
      arguments: arguments,
    );
  },

  //考勤记录
  "/coursePlan": (context, {arguments}) {
    return CoursePlan(
      arguments: arguments,
    );
  },

  //一日一题详情
  "/dayTopicDetail": (context, {arguments}) {
    return DayTopicDetail(
      arguments: arguments,
    );
  },

  //证书详情
  "/certificateDetail": (context, {arguments}) {
    return CertificateDetail(
      arguments: arguments,
    );
  },

  //公告详情
  "/afficheDetail": (context, {arguments}) {
    return AfficheDetail(
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
