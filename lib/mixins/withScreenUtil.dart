import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class MyScreenUtil {
  num dp(double width) {
    return ScreenUtil().setWidth(width);
  }
}
