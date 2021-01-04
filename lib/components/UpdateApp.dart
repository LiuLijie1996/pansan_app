import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:package_info/package_info.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import './UpdateAlter.dart';
import '../models/AppInfoDataType.dart';

///上次检查更新的时间
int preExamineTime = 0;

///更新app
class UpdateApp extends StatefulWidget {
  Widget child;
  UpdateApp({Key key, this.child}) : super(key: key);

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> with UpdateAlter, AppInfoMixin {
  ///更新的信息
  List updateContent = [];

  ///下次提醒更新的最大时间
  int maxTime = 6 * 60 * 60 * 1000;

  @override
  void initState() {
    super.initState();

    // 初始化
    this.myInitialize();
  }

  // 初始化
  myInitialize() {
    // 检查更新App
    this.examineUpdateApp();
  }

  // 检查更新APP
  examineUpdateApp() async {
    // 当前时间
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    // 判断是否需要提醒更新应用
    print("判断是否需要提醒更新应用");
    if (currentTime - preExamineTime < maxTime) return;
    // 更新检查的时间
    preExamineTime = DateTime.now().millisecondsSinceEpoch;

    // 获取应用信息
    AppInfoDataType appInfo = await getAppInfo();

    var result = await myRequest(
      path: MyApi.version,
      data: {
        "versionCode": appInfo.buildNumber,
      },
    );
    var data = result['data'];
    if (data['code'] == 0) return;
    updateContent = (json.decode(data['content'])).map((e) {
      return {
        "content": e['content'],
      };
    }).toList();

    // 获取后台保存的最新的版本号
    int versionCode = int.parse("${data['versionCode']}");

    // 判断是否弹窗升级
    if (int.parse(appInfo.buildNumber) < versionCode) {
      // 弹窗提示更新
      this.showAlter(
        context,
        updateContent: updateContent,
        link: data['link'],
        version: data['version'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
