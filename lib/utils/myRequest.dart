export './MyApi.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/UserInfoDataType.dart';
import '../models/AppInfoDataType.dart';
import '../mixins/mixins.dart';
import '../components/LoadWidget.dart';

///请求数据的类
class MyRequest extends UserInfoMixin with LoadWidget, AppInfoMixin {
  ///Dio
  Dio dio = Dio();

  ///应用信息
  AppInfoDataType appInfo;

  ///用户信息
  UserInfoDataType user;

  ///初始后台地址
  String location = 'http://192.168.0.5:80/pansanApp';

  ///是否上线
  bool line;

  ///接口
  String path;

  ///发给后台的数据
  Map<String, dynamic> query;

  MyRequest({this.line = false}) {
    // 如果项目上线了，将后台地址改成线上的
    if (this.line) {
      location = "http://192.168.0.8:88/index.php/v2";
    }
  }

  ///发起请求
  Future<Map> request({
    ///上下文
    BuildContext context,

    ///请求方式  post请求    get请求   upload上传文件  download下载文件
    String method = "post",

    ///上传（下载）文件时，文件的地址  将method改成upload类型
    String filePath,

    ///请求地址
    String path = "",

    ///发送的数据
    Map<String, dynamic> data,
  }) async {
    // 获取用户信息
    this.user = await this.userInfo();

    // 应用信息
    this.appInfo = await this.getAppInfo();

    // 接口
    this.path = path;

    // 设置发给后台的数据
    this.setSendData(data);

    // 请求数据
    Map result;
    switch (method) {
      case 'post':
        result = await this.postData();
        break;
      case 'get':
        result = await this.getData();
        break;
      case 'upload':
        result = await this.uploadFile(filePath: filePath);
        break;
      case 'download':
        result = await this.downloadFile(context: context, fileUrl: filePath);
        break;
    }

    // 后台返回的数据
    return result;
  }

  /// get请求数据
  Future getData() async {
    Response response = await dio.get(
      this.location + this.path, //拼接完整的接口
      queryParameters: this.query,
      options: Options(
        headers: {
          "token": this.user != null ? this.user.token : null,
          "versionCode": this.appInfo.buildNumber,
        },
      ),
    );

    Map data;
    if ((response.data.runtimeType).toString() == 'String') {
      data = json.decode(response.data);
    } else {
      data = response.data;
    }

    // 返回请求到的数据
    return data;
  }

  /// post请求数据
  Future postData() async {
    Response response = await dio.post(
      this.location + this.path, //拼接完整的接口
      data: this.query,
      options: Options(
        headers: {
          "token": this.user != null ? this.user.token : null,
          "versionCode": this.appInfo.buildNumber,
        },
      ),
    );

    print("完整的接口：${this.location + this.path}");
    print("post请求到的数据：${response.data}");
    print((response.data.runtimeType).toString());

    Map data;
    if ((response.data.runtimeType).toString() == 'String') {
      data = json.decode(response.data);
    } else {
      data = response.data;
    }

    // 返回请求到的数据
    return data;
  }

  ///上传文件
  Future uploadFile({
    ///文件地址
    String filePath,
  }) async {
    FormData formdata = FormData.fromMap({
      // "fileUpload" 相当于网页的 input 输入框的 name 值一样
      "file": await MultipartFile.fromFile(
        filePath, //文件路径
        // filename: "pic", //图片名称
      )
    });

    print("接口：${this.location + this.path}");

    // Map<String, dynamic> map = {'fileType': "KTP_IMG"};
    //上传结果
    Response response = await dio.post(
      this.location + this.path, //拼接完整的接口
      data: formdata,
      options: Options(
        headers: {
          "token": this.user != null ? this.user.token : null,
        },
      ),
      // queryParameters: map,
      onSendProgress: (int count, int total) {
        var rate = "${(count / total * 100).floor()}%";
        print('-----------$rate-------------'); //上传进度
      },
    );

    return json.decode(response.data);
  }

  ///下载文件
  Future downloadFile({
    ///上下文
    BuildContext context,

    ///文件地址
    String fileUrl,
  }) async {
    try {
      // 获取权限
      await isGrantedFn();

      // //获取文档地址
      // String dir = (await getApplicationDocumentsDirectory()).path;

      String dir;
      if (Theme.of(context).platform == TargetPlatform.android) {
        //获取android文档地址
        dir = (await getExternalStorageDirectory()).path;
      } else {
        //获取ios文档地址
        dir = (await getApplicationDocumentsDirectory()).path;
      }

      print("获取文档地址  $dir");
      print("文件Url  $fileUrl");

      List fileSplit = fileUrl.split("/");
      // 获取文件名称
      String fileName = fileSplit[fileSplit.length - 1];
      //拼接保存路径
      File file = File("$dir/$fileName");
      print("保存路径：${file.path}");

      // 保存路径
      var filePath = file.path;

      //判断文件是否存在
      bool isEmpty = file.existsSync();
      if (isEmpty) {
        Fluttertoast.showToast(
          msg: "文件已存在",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // 下载文件
      try {
        Response response = await dio.download(
          fileUrl,
          filePath,
          onReceiveProgress: (count, total) {
            var progress = (((count / total) * 100).ceil()).toString() + "%";

            // 显示弹窗
            showLoad(context, msg: progress);

            if (progress == '100%') {
              // 隐藏弹窗
              hideLoad(context);
            }
          },
        );
        print("下载完成状态码：${response.statusCode}");
      } catch (e) {
        Fluttertoast.showToast(
          msg: "文件权限过高,下载失败",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // 申请权限
  Future isGrantedFn() async {
    bool status = await Permission.storage.isGranted;
    print("申请权限  $status");
    //判断如果还没拥有读写权限就申请获取权限
    if (!status) {
      return await Permission.storage.request().isGranted;
    }
  }

  // 设置传给后台的数据
  Map<String, dynamic> setSendData(Map<String, dynamic> value) {
    // token：pansan
    // t：时间戳
    // nonce（随机6位字符串）：ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678
    // sign（大写md5）： t + nonce + token

    var str = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678";
    var maxLen = str.length;

    // 秘钥
    var token = "pansan";
    // 随机字符串
    var nonce = '';
    for (var i = 0; i < 6; i++) {
      var random = math.Random();
      int index = random.nextInt(maxLen - 1);
      nonce += str.substring(index, index + 1);
    }

    // 时间戳
    var t = new DateTime.now().millisecondsSinceEpoch;
    // md5加密
    var encode = utf8.encode("$t$nonce$token");
    var sign = md5.convert(encode).toString().toUpperCase();

    // 判断传给后台的数据有没有user_id
    if (value != null && value['user_id'] != null) {
      if (this.user != null) {
        value['user_id'] = this.user.id;
      }
    }

    if (value == null) {
      this.query = {
        "nonce": nonce,
        "t": t,
        "sign": sign,
      };
    } else {
      this.query = {
        ...value,
        "nonce": nonce,
        "t": t,
        "sign": sign,
      };
    }

    print("设置传给后台的数据：${this.query}");

    return this.query;
  }
}

var myRequest = MyRequest().request;
