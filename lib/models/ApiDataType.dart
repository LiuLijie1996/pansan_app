/// api数据类型
class ApiDataType {
  String path;
  String method;

  ApiDataType({
    this.path,
    this.method,
  });

  ApiDataType.fromJson(Map json) {
    this.path = json['path'];
    this.method = json['method'];
  }
}
