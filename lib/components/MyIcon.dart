import 'package:flutter/material.dart';

class MyIcon {
  IconData home = IconData(0xe628, fontFamily: 'iconfont'); //首页
  IconData news = IconData(0xe67a, fontFamily: 'iconfont'); //新闻
  IconData study = IconData(0xe6ec, fontFamily: 'iconfont'); //学习
  IconData test = IconData(0xe604, fontFamily: 'iconfont'); //考试
  IconData my = IconData(0xe624, fontFamily: 'iconfont'); //我的
  IconData sao = IconData(0xe660, fontFamily: 'iconfont'); //扫一扫
  IconData jifen = IconData(0xe614, fontFamily: 'iconfont'); //积分
  IconData time = IconData(0xe6c1, fontFamily: 'iconfont'); //时间
  IconData eye_open = IconData(0xe6c4, fontFamily: 'iconfont'); //眼睛开
  IconData eye_off = IconData(0xe633, fontFamily: 'iconfont'); //眼睛闭
  IconData view = IconData(0xe65f, fontFamily: 'iconfont'); //观看
  IconData arrows_right = IconData(0xe60b, fontFamily: 'iconfont'); //右箭头
  IconData linear_arrows_right =
      IconData(0xe6b0, fontFamily: 'iconfont'); //线性右箭头
  IconData bi = IconData(0xe742, fontFamily: 'iconfont'); //笔
  IconData pwd = IconData(0xe62d, fontFamily: 'iconfont'); //锁
  IconData update = IconData(0xe675, fontFamily: 'iconfont'); //检查更新
  IconData quit = IconData(0xe60f, fontFamily: 'iconfont'); //退出
  IconData verify = IconData(0xe636, fontFamily: 'iconfont'); //验证码
  IconData phone = IconData(0xe634, fontFamily: 'iconfont'); //手机
  IconData id_card = IconData(0xe6ba, fontFamily: 'iconfont'); //身份证
  IconData bell = IconData(0xe623, fontFamily: 'iconfont'); //身份证
  IconData course_plan = IconData(0xe815, fontFamily: 'iconfont'); //课程计划
  IconData record = IconData(0xe6f4, fontFamily: 'iconfont'); //考勤记录
  IconData collect = IconData(0xe610, fontFamily: 'iconfont'); //收藏
  IconData full_collect = IconData(0xe63e, fontFamily: 'iconfont'); //收藏
  IconData correct = IconData(0xe632, fontFamily: 'iconfont'); //正确
  IconData chronograph = IconData(0xe606, fontFamily: 'iconfont'); //秒表

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "home": home,
      "news": news,
      "study": study,
      "test": test,
      "my": my,
      "sao": sao,
      "jifen": jifen,
      "time": time,
      "eye_open": eye_open,
      "eye_off": eye_off,
      "view": view,
      "arrows_right": arrows_right,
      "linear_arrows_right": linear_arrows_right,
      "bi": bi,
      "pwd": pwd,
      "update": update,
      "quit": quit,
      "verify": verify,
      "phone": phone,
      "id_card": id_card,
      "bell": bell,
      "course_plan": course_plan,
      "record": record,
      "collect": collect,
      "full_collect": full_collect,
      "correct": correct,
      "chronograph": chronograph,
    };
  }
}

MyIcon aliIconfont = MyIcon();
Map myIcon = aliIconfont.toJson();

// var myIcon = {
//   "home": const IconData(0xe628, fontFamily: 'iconfont'), //首页
//   "news": const IconData(0xe67a, fontFamily: 'iconfont'), //新闻
//   "study": const IconData(0xe6ec, fontFamily: 'iconfont'), //学习
//   "test": const IconData(0xe604, fontFamily: 'iconfont'), //考试
//   "my": const IconData(0xe624, fontFamily: 'iconfont'), //我的
//   "sao": const IconData(0xe660, fontFamily: 'iconfont'), //扫一扫
//   "jifen": const IconData(0xe614, fontFamily: 'iconfont'), //积分
//   "time": const IconData(0xe6c1, fontFamily: 'iconfont'), //时间
//   "eye-open": const IconData(0xe6c4, fontFamily: 'iconfont'), //眼睛开
//   "eye-off": const IconData(0xe633, fontFamily: 'iconfont'), //眼睛闭
//   "view": const IconData(0xe65f, fontFamily: 'iconfont'), //观看
//   "arrows_right": const IconData(0xe60b, fontFamily: 'iconfont'), //右箭头
//   "linear_arrows_right": const IconData(0xe6b0, fontFamily: 'iconfont'), //线性右箭头
//   "bi": const IconData(0xe742, fontFamily: 'iconfont'), //笔
//   "pwd": const IconData(0xe62d, fontFamily: 'iconfont'), //锁
//   "update": const IconData(0xe675, fontFamily: 'iconfont'), //检查更新
//   "quit": const IconData(0xe60f, fontFamily: 'iconfont'), //退出
//   "verify": const IconData(0xe636, fontFamily: 'iconfont'), //验证码
//   "phone": const IconData(0xe634, fontFamily: 'iconfont'), //手机
//   "id_card": const IconData(0xe6ba, fontFamily: 'iconfont'), //身份证
//   "bell": const IconData(0xe623, fontFamily: 'iconfont'), //身份证
//   "course_plan": const IconData(0xe815, fontFamily: 'iconfont'), //课程计划
//   "record": const IconData(0xe6f4, fontFamily: 'iconfont'), //考勤记录
//   "collect": const IconData(0xe610, fontFamily: 'iconfont'), //收藏
//   "full_collect": const IconData(0xe63e, fontFamily: 'iconfont'), //收藏
//   "correct": const IconData(0xe632, fontFamily: 'iconfont'), //正确
// };
