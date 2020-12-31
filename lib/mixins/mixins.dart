import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../db/UserDB.dart';
import '../models/UserInfoDataType.dart';

///像素适配
abstract class MyScreenUtil {
  num dp(double width) {
    return ScreenUtil().setWidth(width);
  }
}

///用户信息
abstract class UserInfoMixin {
  // 初始化
  Future<UserInfoDataType> get userInfo async {
    // 获取用户信息
    List<UserInfoDataType> userInfoList = await UserDB.findAll();
    if (userInfoList.length != 0) {
      return userInfoList[0];
    }
  }
}
