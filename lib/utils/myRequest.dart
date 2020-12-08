import 'package:dio/dio.dart';
import 'dart:math' as math;

String test = "http://192.168.0.5:3000"; //测试接口
String href = ""; //上线接口

Future myRequest({
  String method = "post", //请求方式
  bool online = false, //线上（true）还是 线下（false）
  String path = "", //请求地址
  dynamic data, //发送的数据
}) async {
  var dio = Dio();
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

//文件上传
//url - 上传的地址
//filePath - 本地文件路径
Future<Response> dioUpload({
  String path = "",
  String filePath,
  bool online = false,
}) async {
  var dio = Dio();
  // 拼接接口
  var url = online ? href + path : test + path;

  FormData formdata = FormData.fromMap({
    // "fileUpload" 相当于网页的 input 输入框的 name 值一样
    "fileUpload": await MultipartFile.fromFile(
      filePath, //文件路径
      // filename: "pic", //图片名称
    )
  });

  // Map<String, dynamic> map = {'fileType': "KTP_IMG"};
  //上传结果
  var result = await dio.post(
    url,
    data: formdata,
    // queryParameters: map,
    onSendProgress: (int count, int total) {
      var rate = "${(count / total * 100) ~/ 1}%";

      print('-----------$rate-------------'); //上传进度
    },
  );

  return result;
}
