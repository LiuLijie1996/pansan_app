import 'package:flutter/material.dart';
import 'index.dart';
import 'my.dart';
import 'news.dart';
import 'study.dart';
import 'exam.dart';

// 底部导航
class MyBottomNavigationBar extends StatefulWidget {
  final currentIndex;
  MyBottomNavigationBar({Key key, this.currentIndex=0}) : super(key: key);

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
    return Scaffold(
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
    );
  }
}
