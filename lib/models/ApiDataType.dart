/// api数据类型
class ApiDataType {
  ///请求方法
  String method;

  ///正常的接口地址
  String normal;

  ///测试用的接口地址
  String test;

  ApiDataType({
    this.method,
    this.normal,
    this.test,
  });

  ApiDataType.fromJson(Map json) {
    this.method = json['method'];
    this.normal = json['normal'];
    this.test = json['test'];
  }
}
