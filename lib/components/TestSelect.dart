import 'package:flutter/material.dart';
import 'package:pansan_app/components/MyChoiceButton.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/IssueDataType.dart';

// 题目选择
class MultipleChoice extends StatelessWidget with MyScreenUtil {
  final bool reminder; //是否需要错误提示
  final IssueDataType data; //数据
  final Function onChange; //选择答案时触发的回调
  final bool disabled; //是否禁止点击
  MultipleChoice({
    Key key,
    this.reminder = false,
    this.data,
    this.onChange,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 问题标题
        Text(
          "${data.stem}",
          style: TextStyle(
            fontSize: dp(36.0),
            height: 1.2,
          ),
        ),
        // 各种选项
        Column(
          children: data.option.map((e) {
            // 用户选择的答案
            List<String> user_answer = data.userAnswer;
            bool status = null;
            // 判断用户是否选择了
            if (user_answer.length == 0) {
              status = null;
            } else {
              // 判断当前按钮是否被选择
              bool is_select = user_answer.contains(e.label);
              // 如果选择了赋值一个true
              if (is_select) {
                status = true;

                // 判断是否需要错误提示
                if (reminder) {
                  for (var i = 0; i < user_answer.length; i++) {
                    if (e.label == user_answer[i]) {
                      // 判断用户的选项是否包含在标准答案中
                      status = data.answer.contains(user_answer[i]);
                    }
                  }
                }
              }
            }
            // 选择按钮
            return MyChoiceButton(
              option: e,
              status: status,
              disabled: disabled,
              onClick: () {
                onChange(e);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
