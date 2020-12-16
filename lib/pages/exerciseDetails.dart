// 练习详情
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pansan_app/components/TestSelect.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/examIssueType.dart';
import 'package:pansan_app/components/MyIcon.dart';

class ExerciseDetails extends StatefulWidget {
  final Map arguments;

  ExerciseDetails({Key key, this.arguments}) : super(key: key);

  @override
  _ExerciseDetailsState createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> with MyScreenUtil {
  // 轮播图控制器
  SwiperController _swiperController = SwiperController();

  // 题目列表
  List<ExamIssueDataType> dataList = [];

  //当前题目下标
  int _currentIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    getDataList();
  }

  @override
  Widget build(BuildContext context) {
    // 当前显示的题目
    ExamIssueDataType _currentItem = dataList[_currentIndex - 1];
    // 1单选 3判断 2多选 4填空
    String textType = '';
    if (_currentItem.type == 1) {
      textType = '单选';
    } else if (_currentItem.type == 2) {
      textType = '多选';
    } else if (_currentItem.type == 3) {
      textType = '判断';
    } else {
      textType = '填空';
    }

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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // 上一题按钮
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(
                "上一题",
                style: TextStyle(
                  color: _currentIndex == 1 ? Colors.grey : Colors.blue,
                ),
              ),
              onPressed: () {
                if (_currentIndex - 1 != 0) {
                  _swiperController.previous();
                }
              },
            ),
            // 收藏按钮
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: UnconstrainedBox(
                child: Column(
                  children: [
                    SizedBox(height: dp(5.0)),
                    Icon(
                      dataList[_currentIndex - 1].userFavor
                          ? myIcon['full_collect']
                          : myIcon['collect'],
                      color: dataList[_currentIndex - 1].userFavor
                          ? Colors.red
                          : Colors.blue,
                    ),
                    Text(
                      dataList[_currentIndex - 1].userFavor ? "已收藏" : "收藏",
                      style: TextStyle(
                        color: dataList[_currentIndex - 1].userFavor
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                    SizedBox(height: dp(5.0)),
                  ],
                ),
              ),
              onPressed: () {
                setState(() {
                  bool userFavor = dataList[_currentIndex - 1].userFavor;
                  dataList[_currentIndex - 1].userFavor = !userFavor;
                });
              },
            ),
            // 交卷按钮
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: UnconstrainedBox(
                child: Column(
                  children: [
                    SizedBox(height: dp(5.0)),
                    Icon(
                      myIcon['correct'],
                      color: Colors.blue,
                    ),
                    Text(
                      "交卷",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: dp(5.0)),
                  ],
                ),
              ),
              onPressed: () {
                // 判断是否做完了
                for (var i = 0; i < dataList.length; i++) {
                  ExamIssueDataType item = dataList[i];
                  if (item.correct == null) {
                    // 弹窗提示
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("提示"),
                          content: Text("题目还没有做完，是否确认交卷？"),
                          actions: [
                            FlatButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("确认"),
                              onPressed: () {
                                // 跳转到 答题报告（练习结束）
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ExerciseOver(dataList: dataList);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return false;
                  }
                }
              },
            ),
            // 下一题按钮
            FlatButton(
              child: Text(
                "下一题",
                style: TextStyle(
                  color: _currentIndex == dataList.length
                      ? Colors.grey
                      : Colors.blue,
                ),
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                if (_currentIndex < dataList.length) {
                  _swiperController.next();
                }
              },
            ),
          ],
        ),
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
                  "$textType",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "$_currentIndex/${dataList.length}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            //轮播
            child: Swiper(
              loop: false,
              controller: _swiperController,
              onIndexChanged: (int index) {
                setState(() {
                  _currentIndex = index + 1;
                });
              },
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                ExamIssueDataType item = dataList[index];

                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: dp(30.0),
                      right: dp(30.0),
                      top: dp(20.0),
                      bottom: dp(20.0),
                    ),
                    child: MultipleChoice(
                      data: item,
                      reminder: true, //是否需要提示
                      // disabled: true, //是否禁止点击
                      onChange: (ChoiceList choiceList) {
                        // 判断是单选还是多选
                        if (item.type == 3 || item.type == 1) {
                          item.user_answer = [];

                          _swiperController.next();
                        }

                        // 判断当前选择的是否已经选择过了
                        bool is_select =
                            item.user_answer.contains(choiceList.label);
                        // 如果已经选了，那么就删除
                        if (is_select) {
                          int index =
                              item.user_answer.indexOf(choiceList.label);

                          // 删除选项
                          item.user_answer.removeAt(index);
                        } else {
                          // 如果没有选择，就添加选项
                          item.user_answer.add(choiceList.label);
                        }

                        // 数组排序
                        item.user_answer.sort((left, right) {
                          return left.compareTo(right);
                        });

                        // 判断两数组的值是否相同
                        bool equals(List array1, List array2) {
                          if (array1.length != array2.length) return false;
                          for (int i = 0; i < array1.length; i++) {
                            if (array1[i] != array2[i]) return false;
                          }
                          return true;
                        }

                        // 判断和标准答案是否相同
                        item.correct = equals(item.user_answer, item.answer);

                        // 刷新页面
                        setState(() {});
                      },
                    ),
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
    // 1单选 3判断 2多选 4填空
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
        "type": 2,
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
      },
      {
        "id": 13505,
        "type": 2,
        "stem": "谁离开的风景粮食局公司就两三点尽量少就过来说了疯狂过",
        "option": [
          {"label": "A", "value": "创建"},
          {"label": "B", "value": "额外"},
          {"label": "C", "value": "的疯狂了"},
          {"label": "D", "value": "破副本"},
          {"label": "E", "value": "丹佛排水沟IE"},
          {"label": "F", "value": "v传播ID片"},
          {"label": "G", "value": "诶无"},
          {"label": "H", "value": "阿佛风"},
          {"label": "I", "value": "比偶当然"},
        ],
        "answer": ["A", "C", "I"], //正确答案
        "analysis": "绿色的风景水果机的", //答案解析
        "disorder": "5", //当前题目分数
        "userFavor": true, //用户是否收藏
      },
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
        id: e['id'], //id
        stem: e['stem'], //标题
        type: e['type'], //题目类型
        option: option, //题目选项
        answer: e['answer'], //正确答案
        analysis: e['analysis'], //答案解析
        disorder: e['disorder'], //当前题目分数
        userFavor: e['userFavor'], //用户是否收藏
        user_answer: [], //用户选择的答案
        correct: null, //用户的选择是否正确
        expend_time: 0, //考试消耗时间
      );
    }).toList();

    setState(() {});
  }
}

// 答题报告（练习结束）
class ExerciseOver extends StatelessWidget with MyScreenUtil {
  // 题目列表
  final List<ExamIssueDataType> dataList;
  ExerciseOver({Key key, @required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 未答个数
    int not_answer_num = dataList.where((e) => e.correct == null).length;
    // 正确的个数
    int correct_num = dataList.where((e) => e.correct == true).length;
    // 答错个数
    int mistake_num = dataList.where((e) => e.correct == false).length;
    // 正确率
    int correct_rate = (correct_num / dataList.length * 100).floor();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("答题报告"),
      ),
      body: Container(
        padding: EdgeInsets.all(dp(30.0)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(dp(30.0)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dp(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 未答的
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$not_answer_num',
                                  style: TextStyle(
                                    fontSize: dp(38.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '题',
                                  style: TextStyle(
                                    fontSize: dp(18.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: dp(10.0),
                                height: dp(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(dp(10.0)),
                                ),
                              ),
                              SizedBox(width: dp(5.0)),
                              Text(
                                "未答题",
                                style: TextStyle(
                                  fontSize: dp(14.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // 答对的
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$correct_num',
                                  style: TextStyle(
                                    fontSize: dp(38.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '题',
                                  style: TextStyle(
                                    fontSize: dp(18.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: dp(10.0),
                                height: dp(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(dp(10.0)),
                                ),
                              ),
                              SizedBox(width: dp(5.0)),
                              Text(
                                "答对了",
                                style: TextStyle(
                                  fontSize: dp(14.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // 答错了
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$mistake_num',
                                  style: TextStyle(
                                    fontSize: dp(38.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '题',
                                  style: TextStyle(
                                    fontSize: dp(18.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: dp(10.0),
                                height: dp(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(dp(10.0)),
                                ),
                              ),
                              SizedBox(width: dp(5.0)),
                              Text(
                                "答错了",
                                style: TextStyle(
                                  fontSize: dp(14.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // 正确率
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$correct_rate',
                                  style: TextStyle(
                                    fontSize: dp(38.0),
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    fontSize: dp(18.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "正确率",
                                style: TextStyle(
                                  fontSize: dp(14.0),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 考试消耗时长
                  Container(
                    margin: EdgeInsets.only(top: dp(30.0)),
                    child: Row(
                      children: [
                        Icon(
                          aliIconfont.chronograph,
                          size: dp(25.0),
                        ),
                        SizedBox(width: dp(10.0)),
                        Text(
                          "用时0分17秒",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: dp(16.0),
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 底部按钮
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: dp(50.0)),
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  '查看解析结果',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
