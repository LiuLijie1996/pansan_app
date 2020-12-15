import 'package:flutter/material.dart';
import 'package:pansan_app/components/MyChoiceButton.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/examIssueType.dart';

// 单选题、判断题
class SingleChoice extends StatefulWidget {
  final bool reminder; //是否需要错误提示
  final ExamIssueDataType data;
  final Function(List<String>) onChange; //选择答案时触发的回调
  SingleChoice({
    Key key,
    this.reminder = false,
    this.data,
    this.onChange,
  }) : super(key: key);

  @override
  _SingleChoiceState createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> with MyScreenUtil {
  //两个按钮的状态
  List<Map<String, Object>> buttonStatus = [];

  @override
  void initState() {
    print("单选题");
    super.initState();

    // 定义两个按钮的状态
    widget.data.option.forEach((element) {
      Map<String, dynamic> item = {
        "status": null,
        "label": element.label,
        "value": element.value,
      };

      buttonStatus.add(item);
    });

    /*判断用户是否确定了答案*/
    if (widget.data.is_sure) {
      buttonStatus.forEach((element) {
        element['status'] = widget.data.answer.contains(element['label']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${widget.data.stem}",
          style: TextStyle(
            fontSize: dp(36.0),
            height: 1.2,
          ),
        ),
        Column(
          children: widget.data.option.map((e) {
            var item = buttonStatus.singleWhere((ele) {
              return ele['label'] == e.label;
            });

            bool status = item['status'];

            return MyChoiceButton(
              option: e,
              disabled: widget.data.is_sure, //判断是否已经确定答案了
              status: status,
              onClick: () {
                buttonStatus.forEach((element) {
                  if (element['label'] == e.label) {
                    //判断是否需要错误提示
                    if (widget.reminder) {
                      element['status'] =
                          element['label'] == widget.data.answer[0];
                    } else {
                      element['status'] = true;
                    }
                  } else {
                    element['status'] = null;
                  }
                });
                setState(() {});
                //触发父级的回调
                widget.onChange([e.label]);
              },
            );
          }).toList(),
        ),

        /*提示用户选择的答案是多少*/
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: dp(20.0)),
          child: Text("你的答案是：${widget.data.user_answer}"),
        )
      ],
    );
  }
}

//多选题
class MultipleChoice extends StatefulWidget {
  final bool reminder; //是否需要错误提示
  final ExamIssueDataType data;
  final Function(List<String>) onChange; //选择答案时触发的回调
  MultipleChoice({
    Key key,
    this.reminder = false,
    this.data,
    this.onChange,
  }) : super(key: key);

  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> with MyScreenUtil {
  //两个按钮的状态
  List<Map<String, Object>> buttonStatus = [];

  //用户选择的答案
  List<String> _user_answer = [];

  @override
  void initState() {
    print("多选题");
    super.initState();

    // 定义两个按钮的状态
    widget.data.option.forEach((element) {
      Map<String, dynamic> item = {
        "status": null,
        "label": element.label,
        "value": element.value,
      };

      buttonStatus.add(item);
    });

    /*判断用户是否确定了答案*/
    if (widget.data.is_sure) {
      buttonStatus.forEach((element) {
        element['status'] = widget.data.answer.contains(element['label']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${widget.data.stem}",
          style: TextStyle(
            fontSize: dp(36.0),
            height: 1.2,
          ),
        ),
        Column(
          children: widget.data.option.map((e) {
            //找到对应按钮的状态
            var item = buttonStatus.singleWhere((ele) {
              return ele['label'] == e.label;
            });

            bool status = item['status'];

            return MyChoiceButton(
              option: e,
              status: status,
              onClick: () {
                buttonStatus.forEach((element) {
                  if (element['label'] == e.label) {
                    //判断是否需要错误提示
                    if (widget.reminder) {
                      element['status'] =
                          widget.data.answer.contains(element['label']);
                    } else {
                      element['status'] = true;
                    }
                  } else {
                    element['status'] = null;
                  }
                });

                _user_answer.add("${e.label}");
                var dedu = new Set(); //用set进行去重
                dedu.addAll(_user_answer); //把数组塞进set里
                List<String> newList = dedu.toList().map((e){
                  return "$e";
                }).toList();

                setState(() {
                  _user_answer = newList;
                });

                widget.onChange(_user_answer);
              },
            );
          }).toList(),
        ),

        /*提示用户选择的答案是多少*/
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: dp(20.0)),
          child: Text("你的答案是：${widget.data.user_answer}"),
        ),
      ],
    );
  }
}
