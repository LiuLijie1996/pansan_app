///应用信息数据类型
class AppInfoDataType {
  String appName;
  String packageName;
  String version;
  String buildNumber;

  AppInfoDataType(
      {this.appName, this.packageName, this.version, this.buildNumber});

  AppInfoDataType.fromJson(Map<String, dynamic> json) {
    appName = json['appName'];
    packageName = json['packageName'];
    version = json['version'];
    buildNumber = json['buildNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appName'] = this.appName;
    data['packageName'] = this.packageName;
    data['version'] = this.version;
    data['buildNumber'] = this.buildNumber;
    return data;
  }
}
