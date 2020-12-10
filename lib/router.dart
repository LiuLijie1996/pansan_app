import 'package:flutter/material.dart';
import 'package:pansan_app/pages/addAdvisory.dart';
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

Map<String, Function> routers = {
  "/": (context) => MyBottomNavigationBar(),
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
  "/courseList": (context, {arguments}) {
    //课程列表
    return SearchCourseList(arguments: arguments);
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
