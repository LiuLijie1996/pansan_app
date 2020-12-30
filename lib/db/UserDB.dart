import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/UserInfoDataType.dart';

///用户数据库
abstract class UserDB {
  // 连接数据库
  static Future<Database> database() async {
    // 获取数据库地址
    String dataPath = await getDatabasesPath();

    // 拼接数据库路径
    String dbPath = path.join(dataPath, 'users.db');

    // 获取数据库
    var database = openDatabase(
      ///数据库地址
      dbPath,

      /// 创建表
      onCreate: (db, version) async {
        print("创建表,版本号为：$version");
        db.execute('''CREATE TABLE users(
          id INTEGER PRIMARY KEY, 
          pid int,
          name TEXT,
          password TEXT,
          headUrl TEXT,
          sex int,
          birthday int,
          idCard TEXT,
          No TEXT,
          phone TEXT,
          department int,
          education TEXT,
          title TEXT,
          job TEXT,
          type_work TEXT,
          politics_status TEXT,
          party_time TEXT,
          native TEXT,
          addtime int,
          status int,
          token TEXT,
          expire_time int,
          cid TEXT,
          jobtime int,
          job_work TEXT,
          skill_level TEXT,
          bindPhone int
        )''');
      },

      onUpgrade: (db, oldVersion, newVersion) {
        print("old：$oldVersion ; new: $newVersion");
      },

      ///数据库版本
      version: 1,
    );

    return database;
  }

  // 存储数据
  static Future<int> addData(UserInfoDataType data) async {
    // 建立连接
    final Database db = await database();

    // 插入数据
    int id = await db.insert(
      'users',
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("保存用户信息成功");

    return id;
  }

  // 获取所有数据
  static Future<List<UserInfoDataType>> findAll() async {
    // 建立连接
    final Database db = await database();

    // 获取所有数据
    List<Map<String, dynamic>> maps = await db.query('users');

    print("获取所有用户信息成功");

    // 格式化数据
    return List.generate(
      maps.length,
      (index) {
        return UserInfoDataType.fromJson(maps[index]);
      },
    );
  }

  // 修改数据
  static Future<UserInfoDataType> update(UserInfoDataType data) async {
    // 建立连接
    final Database db = await database();

    // 修改数据
    await db.update(
      "users", //数据表
      data.toJson(), //新数据
      where: "id=${data.id}", //查询条件
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("修改用户信息成功");
  }

  // 删除数据
  static Future delete() async {
    // 建立连接
    final Database db = await database();

    // 删除数据
    await db.delete("users");

    print("删除用户信息成功");
  }

  // 关闭数据库
  static Future<void> dispose() async {
    final Database db = await database();
    db.close();
  }
}
