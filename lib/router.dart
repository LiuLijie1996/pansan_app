import 'package:flutter/material.dart';
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
