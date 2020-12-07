import 'package:dio/dio.dart';

var dio = Dio();

String test = "http://192.168.0.5:3000"; //测试接口
String href = ""; //上线接口

Future myRequest({
  String method = "post", //请求方式
  bool online = false, //线上（true）还是 线下（false）
  String path = "", //请求地址
  Map data, //发送的数据
}) async {
  // 拼接接口
  var url = online ? href + path : test + path;

  Response response;
  if (method == 'post') {
    response = await dio.post(url, data: data);
  } else {
    response = await dio.get(url, queryParameters: data);
  }

  return response.data;
}
