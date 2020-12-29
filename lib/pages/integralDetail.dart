// 积分明细

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/EmptyBox.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';

// 积分明细数据类型
class IntegralDataType {
  int id;
  int pid;
  int user_id;

  /// 1登录  2考试  3看新闻  5课程  6一日一题
  int type;
  int addtime;
  int branch;
  int d_id;

  IntegralDataType.formJson(Map json) {
    this.id = json['id'];
    this.pid = json['pid'];
    this.user_id = json['user_id'];
    this.type = json['type'];
    this.addtime = json['addtime'];
    this.branch = json['branch'];
    this.d_id = json['d_id'];
  }
}

class IntegralDetail extends StatefulWidget {
  IntegralDetail({Key key}) : super(key: key);

  @override
  _IntegralDetailState createState() => _IntegralDetailState();
}

class _IntegralDetailState extends State<IntegralDetail> with MyScreenUtil {
  ///积分列表
  List<IntegralDataType> integralList = [];

  ///日积分
  int dayScore = 0;

  ///选择的时间
  int selectTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取积分明细
    this.getUserScoreList();
  }

  // 获取积分明细
  getUserScoreList() async {
    try {
      var result = await myRequest(
        path: MyApi.getUserScoreList,
        data: {
          "user_id": 1,
          "page": 1,
          "psize": 20,
          "integral_date": selectTime,
        },
      );

      List data = result['data']['list'];
      dayScore = result['data']['score'];
      integralList = data.map((e) {
        return IntegralDataType.formJson({
          "id": e['id'],
          "pid": e['pid'],
          "user_id": e['user_id'],
          "type": e['type'],
          "addtime": e['addtime'],
          "branch": e['branch'],
          "d_id": e['d_id'],
        });
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {}
  }

  // 日历
  Future<DateTime> _showDatePicker(BuildContext context) {
    // 初始时间
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(selectTime);

    // 最小时间
    DateTime firstDate = new DateTime.now().add(Duration(days: -365));

    // 最大时间
    DateTime lastDate = new DateTime.now();

    return showDatePicker(
      context: context,
      initialDate: date, //初始时间
      firstDate: firstDate, //最小时间
      lastDate: lastDate, //最大时间
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("积分明细"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: dp(200.0),
            padding: EdgeInsets.all(dp(20.0)),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "100",
              style: TextStyle(
                color: Colors.white,
                fontSize: dp(100.0),
              ),
            ),
          ),

          // 积分列表
          Container(
            padding: EdgeInsets.all(dp(20.0)),
            margin: EdgeInsets.only(
              top: dp(150.0),
              bottom: dp(20.0),
              left: dp(20.0),
              right: dp(20.0),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(dp(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[100],
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: integralList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  DateTime time = DateTime.fromMillisecondsSinceEpoch(
                    selectTime,
                  );
                  var _selectTime = formatDate(
                    time,
                    [yyyy, '-', mm, '-', dd],
                  );

                  return Container(
                    padding: EdgeInsets.all(dp(20.0)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "日积累 $dayScore 分",
                          style: TextStyle(
                            fontSize: dp(32.0),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime result = await _showDatePicker(context);
                            if (result != null) {
                              selectTime = result.millisecondsSinceEpoch;
                              setState(() {});

                              // 请求数据
                              getUserScoreList();
                            }
                          },
                          child: Text(
                            "$_selectTime",
                            style: TextStyle(
                              fontSize: dp(32.0),
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                int i = index - 1;
                IntegralDataType item = integralList[i];
                String type = '';

                if (item.type == 1) {
                  type = '登录';
                } else if (item.type == 2) {
                  type = '考试';
                } else if (item.type == 3) {
                  type = '看新闻';
                } else if (item.type == 5) {
                  type = '课程';
                } else if (item.type == 6) {
                  type = '一日一题';
                }

                DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
                  item.addtime * 1000,
                );
                String _addtime = formatDate(
                  addtime,
                  [yyyy, '-', mm, '-', dd, " ", HH, ":", mm],
                );

                return Container(
                  padding: EdgeInsets.all(dp(20.0)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$type"),
                      Text("$_addtime"),
                    ],
                  ),
                );
              },
            ),
          ),

          integralList.length == 0 ? EmptyBox() : Container(),
        ],
      ),
    );
  }
}
