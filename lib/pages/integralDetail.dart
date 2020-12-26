// 积分明细

import 'package:flutter/material.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';

// 积分明细数据类型
class IntegralDataType {
  int id;
  int pid;
  int user_id;
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
  List<IntegralDataType> integralList = [];
  int dayScore = 0; //日积分

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取积分明细
    this.getUserScoreList();
  }

  // 积分明细
  getUserScoreList() async {
    try {
      var result = await myRequest(
        path: "/api/user/getUserScoreList",
        data: {
          "user_id": 1,
          "page": 1,
          "psize": 20,
          "integral_date": 1604246400000,
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
                fontSize: dp(50.0),
              ),
            ),
          ),

          // 积分列表
          Container(
            padding: EdgeInsets.all(dp(20.0)),
            margin: EdgeInsets.only(
              top: dp(100.0),
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
                        Text("日积累 $dayScore 分"),
                        Text("2020-12-26"),
                      ],
                    ),
                  );
                }
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
                      Text("$index"),
                      Text("2020-12-26"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
