import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../db/UserDB.dart';
import '../models/UserInfoDataType.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  // 是否登录了
  bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    // 设置启动页
    setStartPage();

    // 判断是否登录
    judgeLogin();
  }

  // 设置启动页
  setStartPage() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3)).then((value) {
          // 判断有没有登录
          if (isLogin) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => route == null,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => route == null,
            );
          }
        });
      }
    });

    // 开启动画
    _controller.forward();
  }

  // 判断是否登录
  judgeLogin() async {
    // 获取用户信息
    List<UserInfoDataType> list = await UserDB.findAll();
    if (list.length != 0) {
      UserInfoDataType userInfo = list[0];
      int expireTime = userInfo.expireTime * 1000;
      int currenTime = new DateTime.now().millisecondsSinceEpoch;
      isLogin = expireTime > currenTime;
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(750, 1280),
      allowFontScaling: false,
    );
    return FadeTransition(
      opacity: _controller,
      child: Image.asset(
        "assets/images/start_image.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
