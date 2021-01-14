import 'package:flutter/material.dart';
import '../mixins/mixins.dart';
import '../models/IssueDataType.dart';

//考试选项的按钮
class MyChoiceButton extends StatelessWidget with MyScreenUtil {
  ///状态  null未选择  true选择正确  false选择错误
  final bool status;

  ///选项
  final Option option;

  ///是否禁止点击
  final bool disabled;

  ///点击的回调
  final Function onClick;

  MyChoiceButton({
    Key key,
    @required this.status,
    @required this.option,
    this.disabled = false,
    this.onClick,
  }) : super(key: key) {
    //初始化按钮的颜色值
    initStatus();
  }

  // 按钮
  Map button = {
    "borderColor": Colors.grey[300], //边框颜色
    "textColor": Colors.black, //文字颜色
    "backgroundColor": Colors.grey[100], //背景颜色
  };
  // label
  Map label = {
    "borderColor": Colors.grey[300], //边框颜色
    "textColor": Colors.grey, //文字颜色
    "backgroundColor": Colors.white, //背景颜色
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: dp(20.0)),
      child: InkWell(
        onTap: () {
          if (!disabled) {
            // 触发父级的回调
            onClick();
          }
        },
        child: Container(
          padding: EdgeInsets.only(
            top: dp(20.0),
            bottom: dp(20.0),
            left: dp(20.0),
            right: dp(20.0),
          ),
          decoration: BoxDecoration(
            color: button['backgroundColor'],
            border: Border.all(
              color: button['borderColor'],
            ),
            borderRadius: BorderRadius.circular(dp(16.0)),
          ),
          child: Row(
            children: [
              // label
              Container(
                width: dp(60.0),
                height: dp(60.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: label['backgroundColor'], //label的背景
                  border: Border.all(
                    color: label['borderColor'], //label的边框
                  ),
                  borderRadius: BorderRadius.circular(dp(200.0)),
                ),
                child: Text(
                  "${option.label}",
                  style: TextStyle(
                    color: label['textColor'], //label的文字
                  ),
                ),
              ),
              SizedBox(width: dp(20.0)),
              Expanded(
                child: Text(
                  "${option.value}",
                  style: TextStyle(
                    fontSize: dp(32.0),
                    height: 1.1,
                    color: button['textColor'],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //初始化按钮的颜色值
  initStatus() {
    if (status == false) {
      // 选择错误时的颜色
      button = {
        "borderColor": Colors.red[300], //边框颜色
        "textColor": Colors.red, //文字颜色
        "backgroundColor": Colors.red[100], //背景颜色
      };
      label = {
        "borderColor": Colors.red[300], //边框颜色
        "textColor": Colors.white, //文字颜色
        "backgroundColor": Colors.red, //背景颜色
      };
    } else if (status == true) {
      // 选择正确时的颜色
      button = {
        "borderColor": Colors.blue[300], //边框颜色
        "textColor": Colors.blue, //文字颜色
        "backgroundColor": Colors.blue[100], //背景颜色
      };
      label = {
        "borderColor": Colors.blue[300], //边框颜色
        "textColor": Colors.white, //文字颜色
        "backgroundColor": Colors.blue, //背景颜色
      };
    }
  }
}
