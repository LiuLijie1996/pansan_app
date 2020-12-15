// 练习详情

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pansan_app/components/TestSelect.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/examIssueType.dart';

class ExerciseDetails extends StatefulWidget {
  final Map arguments;

  ExerciseDetails({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseDetailsState createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> with MyScreenUtil {
  // 题目列表
  List<ExamIssueDataType> dataList = [];

  //当前题目下标
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    getDataList();
  }

  @override
  Widget build(BuildContext context) {
    //当前题目是否确定选择了
    var is_sure = dataList[_currentIndex].is_sure;

    // 底部导航
    List<BottomNavigationBarItem> bottomNav = [
      BottomNavigationBarItem(
        icon: Icon(Icons.keyboard_arrow_left),
        label: "上一题",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.grade),
        label: "收藏",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.save,
          color: is_sure ? Colors.grey : Colors.black,
        ),
        label: "确定",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.keyboard_arrow_right),
        label: "下一题",
      ),
    ];

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
        onTap: (int index) {
          if (index == 0) {
          } else if (index == 1) {
          } else if (index == 2) {
            if (is_sure == false) {
              setState(() {
                dataList[_currentIndex].is_sure = true;
              });
            }
          } else if (index == 3) {}
        },
        items: bottomNav,
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
            //轮播
            child: Swiper(
              loop: false,
              onIndexChanged: (int index) {
                setState(() {
                  //判断用户是否选择了
                  if (dataList[_currentIndex].user_answer.length != 0) {
                    dataList[_currentIndex].is_sure = true;
                  }
                  _currentIndex = index;
                });
              },
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                ExamIssueDataType item = dataList[index];

                Widget _choice = SingleChoice(
                  data: item,
                  onChange: (List<String> obj) {
                    setState(() {
                      dataList[index].user_answer = obj;
                    });
                  },
                );

                print("${item.type}");

                if (item.type == 1) {
                  //多选题
                  _choice = MultipleChoice(
                    data: item,
                    onChange: (List<String> obj) {
                      setState(() {
                        dataList[index].user_answer = obj;
                      });
                    },
                  );
                }

                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: dp(30.0),
                      right: dp(30.0),
                      top: dp(20.0),
                      bottom: dp(20.0),
                    ),
                    child: _choice,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 获取数据
  getDataList() {
    List listData = [
      {
        "id": 13505,
        "type": 3,
        "stem": "采掘工作面的空气温度超30℃，机电设备硐室的空气温度超过34℃时，必须停止作业。（对）",
        "option": [
          {"label": "A", "value": "对"},
          {"label": "B", "value": "错"}
        ],
        "answer": ["A"], //正确答案
        "analysis": "", //答案解析
        "disorder": "5", //当前题目分数
        "userFavor": false, //用户是否收藏
      },
      {
        "id": 13505,
        "type": 1,
        "stem": "采掘工作面的空气温度超30℃，机电设备硐室的空气温度超过34℃时，必须停止作业。（对）",
        "option": [
          {"label": "A", "value": "大家发的"},
          {"label": "B", "value": "废话不说的"},
          {"label": "C", "value": "v让法国人"},
          {"label": "D", "value": "的发电厂"},
          {"label": "E", "value": "发的发的"},
          {"label": "F", "value": "人头就喝点水"},
          {"label": "G", "value": "发给你不发给"},
          {"label": "H", "value": "违法污染"},
          {"label": "I", "value": "你干嘛"},
        ],
        "answer": ["C", "F", "H"], //正确答案
        "analysis": "", //答案解析
        "disorder": "5", //当前题目分数
        "userFavor": false, //用户是否收藏
      }
    ];

    dataList = listData.map((e) {
      List options = e['option'];
      List<ChoiceList> option = options.map((item) {
        return ChoiceList(
          label: item['label'],
          value: item['value'],
        );
      }).toList();

      return ExamIssueDataType(
        id: e['id'],
        stem: e['stem'],
        type: e['type'],
        option: option,
        answer: e['answer'],
        analysis: e['analysis'],
        disorder: e['disorder'],
        userFavor: e['userFavor'],
        user_answer: [],
        //用户选择的答案
        is_sure: false, //是否确定选择
      );
    }).toList();

    setState(() {});
  }
}
