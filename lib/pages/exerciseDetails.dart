// 练习详情

import 'package:flutter/material.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/choiceList.dart';
import 'package:pansan_app/models/singleAndJudge.dart';

class ExerciseDetails extends StatefulWidget {
  final Map arguments;
  ExerciseDetails({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseDetailsState createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> with MyScreenUtil {
  // 题目列表
  List<SingleAndJudge> dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    getDataList();
  }

  @override
  Widget build(BuildContext context) {
    print("dataList.length  ${dataList.length}  ${dataList[0]}");
    return Scaffold(
      appBar: AppBar(
        title: Text("技术人员测试"),
        actions: [
          FlatButton(
            onPressed: () {
              print("纠错");
            },
            child: Text(
              "纠错",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_arrow_left),
            label: "上一题",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: "收藏",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_arrow_right),
            label: "下一题",
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: dp(30.0),
              bottom: dp(30.0),
              left: dp(20.0),
              right: dp(20.0),
            ),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "判断题",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "1/50",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  left: dp(30.0),
                  right: dp(30.0),
                  top: dp(20.0),
                  bottom: dp(20.0),
                ),
                // 单选题
                child: SingleChoice(
                  data: dataList[0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getDataList() {
    List listData = [
      {
        "id": 13505,
        "stem": "采掘工作面的空气温度超30℃，机电设备硐室的空气温度超过34℃时，必须停止作业。（对）",
        "option": [
          {"lable": "A", "value": "对"},
          {"lable": "B", "value": "错"}
        ],
        "answer": "A", //正确答案
        "analysis": "", //答案解析
        "disorder": "5", //当前题目分数
        "userFavor": false, //用户是否收藏
      }
    ];

    dataList = listData.map((e) {
      List options = e['option'];
      List<ChoiceList> option = options.map((item) {
        return ChoiceList(
          lable: item['lable'],
          value: item['value'],
        );
      }).toList();
      return SingleAndJudge(
        id: e['id'],
        stem: e['stem'],
        option: option,
        answer: e['answer'],
        analysis: e['analysis'],
        disorder: e['disorder'],
        userFavor: e['userFavor'],
      );
    }).toList();

    setState(() {});
  }
}

// 单选题
class SingleChoice extends StatelessWidget with MyScreenUtil {
  final SingleAndJudge data;
  SingleChoice({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ChoiceList> options = data.option;
    return Column(
      children: [
        Text(
          "${data.stem}",
          style: TextStyle(
            fontSize: dp(36.0),
            height: 1.2,
          ),
        ),
        Column(
          children: options.map((e) {
            return MyChoiceButton(
              option: e,
              select: null,
            );
          }).toList(),
        )
      ],
    );
  }
}

// 按钮
class MyChoiceButton extends StatelessWidget with MyScreenUtil {
  final bool select; //是否选择
  final ChoiceList option; //选择项
  final bool disabled; //是否禁止点击
  const MyChoiceButton({
    Key key,
    this.select,
    @required this.option,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 按钮
    Map button = {
      "borderColor": Colors.grey[300], //边框颜色
      "textColor": Colors.black, //文字颜色
      "backgroundColor": Colors.grey[100], //背景颜色
    };

    // lable
    Map lable = {
      "borderColor": Colors.grey[300], //边框颜色
      "textColor": Colors.grey, //文字颜色
      "backgroundColor": Colors.white, //背景颜色
    };

    if (select == false) {
      // 选择错误时的颜色
      button = {
        "borderColor": Colors.red[300], //边框颜色
        "textColor": Colors.red, //文字颜色
        "backgroundColor": Colors.red[100], //背景颜色
      };
      lable = {
        "borderColor": Colors.red[300], //边框颜色
        "textColor": Colors.white, //文字颜色
        "backgroundColor": Colors.red, //背景颜色
      };
    } else if (select == true) {
      // 选择正确时的颜色
      button = {
        "borderColor": Colors.blue[300], //边框颜色
        "textColor": Colors.blue, //文字颜色
        "backgroundColor": Colors.blue[100], //背景颜色
      };
      lable = {
        "borderColor": Colors.blue[300], //边框颜色
        "textColor": Colors.white, //文字颜色
        "backgroundColor": Colors.blue, //背景颜色
      };
    }

    return Container(
      margin: EdgeInsets.only(top: 20.0),
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
      child: InkWell(
        onTap: () {
          if (!disabled) {
            print(option.toJson());
          }
        },
        child: Row(
          children: [
            // lable
            Container(
              width: dp(60.0),
              height: dp(60.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: lable['backgroundColor'], //lable的背景
                border: Border.all(
                  color: lable['borderColor'], //lable的边框
                ),
                borderRadius: BorderRadius.circular(dp(200.0)),
              ),
              child: Text(
                "${option.lable}",
                style: TextStyle(
                  color: lable['textColor'], //lable的文字
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
    );
  }
}
