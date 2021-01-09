import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../tabbarPages/exam.dart';
import '../tabbarPages/index.dart';
import '../tabbarPages/my.dart';
import '../tabbarPages/news.dart';
import '../tabbarPages/study.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../models/DayTopicDataType.dart';
import '../models/DayTopicDetailDataType.dart';

// 推送
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

// 推送的数据格式（开发坏境）
// var map = {
//   "result": {
//     "dropType": 0,
//     "extrasMap": {
//       "id": "4bq6nlixgiohnm4w00",
//       "channel": "mobpush",
//       "pushData": "{\"id\":\"2397\"}"
//     },
//     "light": true,
//     "voice": true,
//     "offlineFlag": 0,
//     "style": 0,
//     "timestamp": 1609912651810,
//     "shake": true,
//     "mobNotifyId": "1250474957",
//     "content": "模拟发送内容，500字节以内，UTF-8",
//     "channel": 0,
//     "isGuardMsg": false,
//     "messageId": "4bq6nlixgiohnm4w00"
//   },
//   "action": 1
// };

// 推送的数据格式（生产坏境）
// var map = {
//   "result": {
//     "l": true,
//     "i": "4br904665lm10f2txc",
//     "n": 0,
//     "s": 0,
//     "c": 0,
//     "t": false,
//     "j": 1609922788721,
//     "p": 0,
//     "e": "测试推送1",
//     "k": true,
//     "d": "测试推送1",
//     "m": false,
//     "r": "345298397",
//     "h": {
//       "id": "4br904665lm10f2txc",
//       "channel": "mobpush",
//       "pushData": {"id": "2402"}
//     }
//   },
//   "action": 1
// };

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

    // 初始化页面
    this.myInitialize();

    // 初始化推送
    this.pushInitialize();
  }

  // 初始化页面
  myInitialize() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });

    _tabController.animateTo(widget.currentIndex);
  }

  ///推送初始化
  pushInitialize() async {
    if (Platform.isIOS) {
      // 设置远程推送环境，向用户授权（仅 iOS）
      MobpushPlugin.setCustomNotification();

      // 设置远程推送环境 (仅 iOS)
      // 开发环境 false, 线上环境 true
      MobpushPlugin.setAPNsForProduction(false);
    }

    // 监听推送
    MobpushPlugin.addPushReceiver(
      (Object event) async {
        Map<String, dynamic> eventMap = json.decode(event);
        Map<String, dynamic> result = eventMap['result'];

        // 获取状态
        int action = eventMap['action'];

        // 获取额外信息的父级
        Map<String, dynamic> extrasMap;

        if (result["extrasMap"] == null) {
          // 获取额外信息（生产环境）
          extrasMap = result["h"];
        } else {
          // 获取额外信息（开发环境）
          extrasMap = result["extrasMap"];
        }
        // 获取额外信息
        Map<String, dynamic> pushData = json.decode(extrasMap["pushData"]);

        // 判断是否将通知打开了
        if (action == 2) {
          if (pushData['id'] == null) return;

          var result = await myRequest(
            path: MyApi.getOneTodayStudy,
            data: {
              "id": pushData['id'],
            },
          );

          var detail = DayTopicDetailDataType.fromJson({
            "id": result['data']['id'],
            "d_id": result['data']['d_id'],
            "name": result['data']['name'],
            "study_time": result['data']['study_time'],
            "addtime": result['data']['addtime'],
            "content": result['data']['content'],
            "analysis": result['data']['analysis'],
            "status": result['data']['status']
          });

          TimeChildren arguments = TimeChildren.fromJson({
            "id": detail.id,
            "study_time": detail.studyTime,
            "name": detail.name,
          });

          // 跳转到一日一题详情页
          Navigator.pushNamed(
            context,
            "/dayTopicDetail",
            arguments: arguments,
          );
        }
      },
      (Object event) async {
        print("监听的推送报错了：$event");
      },
    );

    //上传隐私协议许可
    MobpushPlugin.updatePrivacyPermissionStatus(true);

    // 获取注册Id
    String rid = await getRegistrationId();
    // 发给后台
    await MyRequest(line: true).request(
      path: MyApi.editUser,
      data: {
        "cid": rid,
        "user_id": true,
      },
    );
  }

  ///测试推送
  testPush() {
    /**
    * 测试模拟推送，用于测试
    * type（int）：模拟消息类型，1、通知测试；2、内推测试；3、定时
    * content（String）：模拟发送内容，500字节以内，UTF-8
    * space（int）：仅对定时消息有效，单位分钟，默认1分钟
    * extras（String）: 附加数据，json字符串
    */
    MobpushPlugin.send(
      1,
      "模拟发送内容，500字节以内，UTF-8",
      1,
      "{id:2397}",
    ).then((Map<String, dynamic> sendMap) {
      print("测试推送：$sendMap");
    });
  }

  ///获取注册Id
  Future<String> getRegistrationId() async {
    Map<String, dynamic> ridMap = await MobpushPlugin.getRegistrationId();

    return ridMap['res'].toString();
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
            msg: "再按一次退出应用",
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
          onTap: (index) async {
            // 测试推送
            // testPush();
          },
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
