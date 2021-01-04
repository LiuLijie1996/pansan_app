// 设置页面
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/MyIcon.dart';
import '../mixins/mixins.dart';
import '../pages/login.dart';
import '../utils/myRequest.dart';
import '../components/UpdateAlter.dart';

class Settings extends StatelessWidget with MyScreenUtil, UpdateAlter {
  Settings({Key key}) : super(key: key);

  // 检查更新APP
  examineUpdateApp(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName; //应用名称
    String packageName = packageInfo.packageName; //包名称
    String version = packageInfo.version; //版本号
    String buildNumber = packageInfo.buildNumber; //小版本号

    Map<String, dynamic> appInfo = {
      "versionCode": buildNumber,
    };

    var result = await myRequest(path: MyApi.version, data: appInfo);
    if (result['code'] == 0) return;
    var data = result['data'];
    String link = data['link'];
    List updateInfo = (json.decode(data['content'])).map((e) {
      return {
        "content": e['content'],
      };
    }).toList();

    // 获取后台保存的最新的版本号
    int versionCode = int.parse("${data['versionCode']}");

    // 判断是否弹窗升级
    if (int.parse(buildNumber) < versionCode) {
      // 弹窗提示升级
      this.showAlter(
        context,
        link: link,
        version: data['version'],
        updateContent: updateInfo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List settingList = [
      {"icon": myIcon['pwd'], "title": "修改密码", "router": "/updatePwd"},
      {"icon": myIcon['update'], "title": "检查更新", "router": ""},
      {"icon": myIcon['quit'], "title": "退出登录", "router": "/login"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: ListView.separated(
        shrinkWrap: true, //让当前ListView构建的子组件尽量伸缩
        physics: NeverScrollableScrollPhysics(), //设置不滑动；既可以设置滑动效果还可以设置不滑动
        itemCount: settingList.length,
        itemBuilder: (BuildContext context, int index) {
          var e = settingList[index];
          return InkWell(
            onTap: () {
              if (e['router'] != '') {
                if (e['router'] == '/login') {
                  // 路由替换
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Login();
                      },
                    ),
                    (route) => route == null,
                  );
                } else {
                  // 路由跳转
                  Navigator.pushNamed(context, "${e['router']}");
                }
              } else {
                examineUpdateApp(context);
              }
            },
            child: Container(
              width: dp(50.0),
              padding: EdgeInsets.only(
                left: dp(20.0),
                right: dp(20.0),
                top: index == 0 ? dp(24.0) : dp(16.0),
                bottom: dp(16.0),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: dp(20.0),
                  ),
                  Icon(e['icon']),
                  SizedBox(
                    width: dp(40.0),
                  ),
                  Text("${e['title']}"),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}
