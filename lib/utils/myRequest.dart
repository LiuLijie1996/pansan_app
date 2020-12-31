import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import './MyApi.dart';
export './MyApi.dart';
import '../models/UserInfoDataType.dart';
import '../mixins/mixins.dart';

///请求数据的类
class MyRequest extends UserInfoMixin {
  ///Dio
  Dio dio = Dio();

  ///用户信息
  UserInfoDataType user;

  ///后台地址
  String location = 'http://192.168.0.5:80/pansanApp';

  ///完整请求接口
  String url;

  ///发给后台的数据
  Map<String, dynamic> query;

  MyRequest({bool line = false}) : super() {
    // 如果项目上线了，将后台地址改成线上的
    if (line) {
      location = "http://192.168.0.8:88/index.php/v2";
    }
  }

  // 初始化
  Future<Map> initialize({
    ///请求方式
    String method = "post",

    ///上传文件时，文件的地址
    String filePath,

    ///请求地址
    String path = "",

    ///发送的数据
    Map<String, dynamic> data,
  }) async {
    // 获取用户信息
    this.user = await userInfo;

    // 拼接接口
    this.url = location + path;

    // 判断需不需要给后台传用户的id
    if (data != null && data['user_id'] != null) {
      data['user_id'] = this.user.id;
    }

    // 发给后台的数据
    this.query = data;

    // 后台返回的数据
    Map result;
    switch (method) {
      case 'post':
        result = await _postData();
        break;
      case 'get':
        result = await _getData();
        break;
      case 'upload':
        result = await _uploadFile(filePath: filePath);
        break;
    }

    return result;
  }

  /// get请求数据
  Future<Map> _getData() async {
    Response response = await dio.get(
      this.url,
      queryParameters: this._newQuery(query: query),
      options: Options(
        headers: {
          "token": user.token,
        },
      ),
    );

    // 返回请求到的数据
    return response.data;
  }

  /// post请求数据
  Future<Map> _postData() async {
    print('post请求数据');
    Response response = await dio.post(
      this.url,
      data: this._newQuery(query: query),
      options: Options(
        headers: {
          "token": user.token,
        },
      ),
    );

    print("$url 发起请求数据  ${response.data['code']}");

    // 返回请求到的数据
    return response.data;
  }

  ///上传文件
  Future<Map> _uploadFile({
    ///文件地址
    String filePath,
  }) async {
    FormData formdata = FormData.fromMap({
      // "fileUpload" 相当于网页的 input 输入框的 name 值一样
      "fileUpload": await MultipartFile.fromFile(
        filePath, //文件路径
        // filename: "pic", //图片名称
      )
    });

    // Map<String, dynamic> map = {'fileType': "KTP_IMG"};
    //上传结果
    Response response = await dio.post(
      this.url,
      data: formdata,
      options: Options(
        headers: {
          "token": this.user.token,
        },
      ),
      // queryParameters: map,
      onSendProgress: (int count, int total) {
        var rate = "${(count / total * 100).floor()}%";
        print('-----------$rate-------------'); //上传进度
      },
    );

    return response.data;
  }

    // 设置传给后台的数据
   Map<String, dynamic> _newQuery({Map<String, dynamic> query}) {
    // token：pansan
    // t：时间戳
    // nonce（随机6位字符串）：ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678
    // sign（大写md5）： t + nonce + token

    // 秘钥
    var token = "pansan";
    var str = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678";
    var maxLen = str.length;
    // 设置的随机字符串
    var nonce = '';
    for (var i = 0; i < 6; i++) {
      var random = math.Random();
      int index = random.nextInt(maxLen - 1);
      nonce += str.substring(index, index + 1);
    }

    // 时间戳
    var t = new DateTime.now().millisecondsSinceEpoch;
    var encode = utf8.encode("$t$nonce$token");
    var sign = md5.convert(encode).toString().toUpperCase();

    Map<String, dynamic> data = {
      "nonce": nonce,
      "t": t,
      "sign": sign,
    };

    if (query != null) {
      data = {
        ...query,
        "nonce": nonce,
        "t": t,
        "sign": sign,
      };
    }

    return data;
  }
}

var myRequest = MyRequest().initialize;
