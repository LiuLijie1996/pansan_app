import 'package:dio/dio.dart';
import './MyApi.dart';
export './MyApi.dart';

//文件上传
//url - 上传的地址
//filePath - 本地文件路径
// Future<Response> dioUpload({
//   String path = "",
//   String filePath,
//   bool online = false,
// }) async {
//   var dio = Dio();
//   // 拼接接口
//   var url = online ? href + path : test + path;

//   FormData formdata = FormData.fromMap({
//     // "fileUpload" 相当于网页的 input 输入框的 name 值一样
//     "fileUpload": await MultipartFile.fromFile(
//       filePath, //文件路径
//       // filename: "pic", //图片名称
//     )
//   });

//   // Map<String, dynamic> map = {'fileType': "KTP_IMG"};
//   //上传结果
//   var result = await dio.post(
//     url,
//     data: formdata,
//     options: Options(
//       headers: {
//         "Token": await MyApi.userToken,
//       },
//     ),
//     // queryParameters: map,
//     onSendProgress: (int count, int total) {
//       var rate = "${(count / total * 100).floor()}%";

//       print('-----------$rate-------------'); //上传进度
//     },
//   );

//   return result;
// }

///公共的类
class Common {
  ///Dio
  Dio dio = Dio();

  ///测试接口
  String test = 'http://192.168.0.5:80/pansanApp';

  ///上线接口
  String line = 'http://192.168.0.8:88/index.php/v2';

  ///完整请求接口
  String url;

  ///发给后台的数据
  Map<String, dynamic> query;
}

///请求数据的类型
class MyRequest extends Common {
  // 初始化
  Future<Map> initialize({
    ///请求方式
    String method = "post",

    ///请求地址
    String path = "",

    ///发送的数据
    Map<String, dynamic> data,
  }) async {
    // 拼接接口
    url = test + path;

    // 判断需不需要给后台传用户的id
    if (data != null && data['user_id'] != null) {
      data['user_id'] = await MyApi.userId;
    }

    this.query = data;

    var result;
    switch (method) {
      case 'post':
        result = await _postData();
        break;
      case 'get':
        result = await _getData();
        break;
    }

    print(path);
    print(result);

    // 返回数据
    return result;
  }

  /// get请求数据
  Future<Map> _getData() async {
    Response response = await dio.get(
      this.url,
      queryParameters: MyApi.newQuery(query: query),
      options: Options(
        headers: {
          "token": await MyApi.userToken,
        },
      ),
    );

    // 返回请求到的数据
    return response.data;
  }

  /// post请求数据
  Future<Map> _postData() async {
    Response response = await dio.post(
      this.url,
      data: MyApi.newQuery(query: query),
      options: Options(
        headers: {
          "token": await MyApi.userToken,
        },
      ),
    );

    // 返回请求到的数据
    return response.data;
  }
}

///下载文件的类型
class Download extends Common {
  ///初始化
  initialize() {}
}

var myRequest = MyRequest().initialize;
