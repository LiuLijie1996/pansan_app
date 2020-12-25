import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../tabbarPages/exam.dart';
import '../tabbarPages/index.dart';
import '../tabbarPages/my.dart';
import '../tabbarPages/news.dart';
import '../tabbarPages/study.dart';

// 底部导航
class MyBottomNavigationBar extends StatefulWidget {
  final currentIndex;
  MyBottomNavigationBar({Key key, this.currentIndex = 0}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  // 选中的底部导航
  int _currentIndex = 0;
  List _pageList = [
    Index(),
    News(),
    Study(),
    Exam(),
    My(),
  ];
  DateTime _preTime; //上次点击时间

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _currentIndex = widget.currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 点击返回键的操作
        if (_preTime == null ||
            DateTime.now().difference(_preTime) > Duration(seconds: 2)) {
          _preTime = DateTime.now();

          Fluttertoast.showToast(
            msg: "你今天真好看",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          _preTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
      child: Scaffold(
        body: _pageList[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/bottom_nav/grey/home.png",
                width: 20.0,
                height: 20.0,
              ),
              activeIcon: Image.asset(
                "assets/bottom_nav/blue/home.png",
                width: 20.0,
                height: 20.0,
              ),
              label: "首页",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/bottom_nav/grey/news.png",
                width: 20.0,
                height: 20.0,
              ),
              activeIcon: Image.asset(
                "assets/bottom_nav/blue/news.png",
                width: 20.0,
                height: 20.0,
              ),
              label: "新闻",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/bottom_nav/grey/study.png",
                width: 20.0,
                height: 20.0,
              ),
              activeIcon: Image.asset(
                "assets/bottom_nav/blue/study.png",
                width: 20.0,
                height: 20.0,
              ),
              label: "学习",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/bottom_nav/grey/exam.png",
                width: 20.0,
                height: 20.0,
              ),
              activeIcon: Image.asset(
                "assets/bottom_nav/blue/exam.png",
                width: 20.0,
                height: 20.0,
              ),
              label: "考试",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/bottom_nav/grey/my.png",
                width: 20.0,
                height: 20.0,
              ),
              activeIcon: Image.asset(
                "assets/bottom_nav/blue/my.png",
                width: 20.0,
                height: 20.0,
              ),
              label: "我的",
            ),
          ],
        ),
      ),
    );
  }
}
