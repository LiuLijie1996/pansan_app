import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../tabbarPages/exam.dart';
import '../tabbarPages/index.dart';
import '../tabbarPages/my.dart';
import '../tabbarPages/news.dart';
import '../tabbarPages/study.dart';
import '../mixins/mixins.dart';

// 底部导航
class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  MyBottomNavigationBar({Key key, this.currentIndex = 0}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _tabController; //需要定义一个Controller
  int tabIndex = 0;
  List tabs = [
    {
      "title": "首页",
      "activeIcon": "assets/bottom_nav/blue/home.png",
      "inactiveIcon": "assets/bottom_nav/grey/home.png",
      "page": Index(),
    },
    {
      "title": "新闻",
      "activeIcon": "assets/bottom_nav/blue/news.png",
      "inactiveIcon": "assets/bottom_nav/grey/news.png",
      "page": News(),
    },
    {
      "title": "学习",
      "activeIcon": "assets/bottom_nav/blue/study.png",
      "inactiveIcon": "assets/bottom_nav/grey/study.png",
      "page": Study(),
    },
    {
      "title": "考试",
      "activeIcon": "assets/bottom_nav/blue/exam.png",
      "inactiveIcon": "assets/bottom_nav/grey/exam.png",
      "page": Exam(),
    },
    {
      "title": "我的",
      "activeIcon": "assets/bottom_nav/blue/my.png",
      "inactiveIcon": "assets/bottom_nav/grey/my.png",
      "page": My(),
    },
  ];

  // 上次点击返回的时间
  DateTime _preTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });

    _tabController.animateTo(widget.currentIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
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

          return Future(() => false);
        } else {
          _preTime = DateTime.now();
          // 退出app
          // return SystemChannels.platform.invokeMethod('SystemNavigator.pop');

          return Future(() => true);
        }
      },
      child: Scaffold(
        bottomNavigationBar: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(),
          tabs: tabs.map((e) {
            int index = tabs.indexOf(e);
            String asset = "${e['inactiveIcon']}";

            // 判断是不是激活状态
            if (tabIndex == index) {
              asset = "${e['activeIcon']}";
            }

            return Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: dp(10.0)),
                    child: Image.asset(
                      "$asset",
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                  Text(
                    "${e['title']}",
                    style: TextStyle(
                      fontSize: dp(26.0),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((e) {
            Widget page = e['page'];
            return MyAppPage(page: page);
          }).toList(),
        ),
      ),
    );
  }
}

class MyAppPage extends StatefulWidget {
  Widget page;
  MyAppPage({Key key, @required this.page}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.page;
  }

  @override
  bool get wantKeepAlive => true;
}
