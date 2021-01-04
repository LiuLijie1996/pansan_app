import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import '../db/UserDB.dart';
import '../models/UserInfoDataType.dart';
import '../models/AppInfoDataType.dart';

///像素适配
abstract class MyScreenUtil {
  num dp(double width) {
    return ScreenUtil().setWidth(width);
  }
}

///用户信息
abstract class UserInfoMixin {
  UserInfoDataType user;

  // 初始化
  Future<UserInfoDataType> userInfo() async {
    // 获取用户信息
    List<UserInfoDataType> userInfoList = await UserDB.findAll();
    if (userInfoList.length != 0) {
      this.user = userInfoList[0];
      return userInfoList[0];
    }
  }
}

///应用信息
abstract class AppInfoMixin {
  Future<AppInfoDataType> getAppInfo() async {
    // 应用信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName; //应用名称
    String packageName = packageInfo.packageName; //包名称
    String version = packageInfo.version; //版本号
    String buildNumber = packageInfo.buildNumber; //小版本号
    return AppInfoDataType.fromJson({
      "appName": appName,
      "packageName": packageName,
      "version": version,
      "buildNumber": buildNumber,
    });
  }
}
