// 题目选择时的列表数据类型
class ChoiceList {
  final String lable;
  final String value;

  ChoiceList({
    this.lable,
    this.value,
  });

  ChoiceList.fromJson(Map<String, dynamic> map)
      : lable = map['lable'],
        value = map['value'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "lable": lable,
      "value": value,
    };
  }
}
