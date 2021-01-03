export './MyApi.dart';
import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/UserInfoDataType.dart';
import '../mixins/mixins.dart';

///请求数据的类
class MyRequest extends UserInfoMixin {
  ///Dio
  Dio dio = Dio();

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
    ///请求方式  post请求    get请求   upload上传文件
    String method = "post",

    ///上传文件时，文件的地址  将method改成upload类型
    String filePath,

    ///请求地址
    String path = "",

    ///发送的数据
    Map<String, dynamic> data,
  }) async {
    // 获取用户信息
    this.user = await userInfo;

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
        },
      ),
    );

    print("get返回的数据：${response.data}");

    // 返回请求到的数据
    return response.data;
  }

  /// post请求数据
  Future postData() async {
    Response response = await dio.post(
      this.location + this.path, //拼接完整的接口
      data: this.query,
      options: Options(
        headers: {
          "token": this.user != null ? this.user.token : null,
        },
      ),
    );

    print("post返回的数据：${response.data}");

    // 返回请求到的数据
    return response.data;
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
