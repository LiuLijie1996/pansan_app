// 本地存储

import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

class LocalStorage {
  /// 存储数据
  static Future save({@required String key, @required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  /// 查找数据
  static Future<String> find(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(key);
    return value;
  }
}
