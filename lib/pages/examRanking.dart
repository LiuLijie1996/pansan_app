// 考试排行

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/NavDataType.dart';
import '../models/ExamRankingDataType.dart';
import '../components/MyProgress.dart';

class ExamRanking extends StatefulWidget {
  ExamRanking({Key key}) : super(key: key);

  @override
  _ExamRankingState createState() => _ExamRankingState();
}

class _ExamRankingState extends State<ExamRanking>
    with MyScreenUtil, SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller

  List<NavDataType> tabs = []; //导航
  List<ExamRankingDataType> rankingList = []; //排行
  ExamRankingDataType myExamRankoing; //自己的排行

  @override
  void initState() {
    super.initState();

    // 初始化数据
    myInitial();
  }

  // 初始化数据
  myInitial() async {
    // 获取导航
    await getNavList();
    // 获取考试排行
    await getExamRanking(id: tabs[0].id);

    // 设置控制器
    _tabController = TabController(vsync: this, length: tabs.length);

    // 监听导航
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        int index = _tabController.index;
        // 获取考试排行
        getExamRanking(id: tabs[index].id);
      }
    });
  }

  // 获取导航
  Future getNavList() async {
    try {
      var result = await myRequest(path: "/api/exam/getTestItemList");
      List data = result['data'];

      List<NavDataType> newData = data.map((e) {
        return NavDataType.fromJson({
          "id": e['id'],
          "d_id": e['d_id'],
          "pid": e['pid'],
          "name": e['name'],
          "sorts": e['sorts'],
          "status": e['status'],
        });
      }).toList();

      tabs.addAll(newData);
    } catch (e) {
      print(e);
    }
  }

  // 获取考试排行
  Future getExamRanking({@required id}) async {
    try {
      var result = await myRequest(
        path: "/api/user/testRankList",
        data: {
          "id": id,
          "user_id": 1,
        },
      );
      List data = result['data'];

      myExamRankoing = ExamRankingDataType.fromJson({
        "rank": result['userTestData']['rank'],
        "fraction": result['userTestData']['fraction'],
        "user": {
          "id": result['userTestData']['user']['id'],
          "name": result['userTestData']['user']['name'],
          "headUrl": result['userTestData']['user']['headUrl'],
          "department": {
            "id": result['userTestData']['user']['department']['id'],
            "name": result['userTestData']['user']['department']['name'],
            "pid": result['userTestData']['user']['department']['pid'],
          }
        }
      });

      rankingList = data.map((e) {
        return ExamRankingDataType.fromJson({
          "id": e['id'],
          "test_id": e['test_id'],
          "user_id": e['user_id'],
          "department_id": e['department_id'],
          "m_test_id": e['m_test_id'],
          "type": e['type'],
          "fraction": e['fraction'],
          "test_time": e['test_time'],
          "addtime": e['addtime'],
          "sorts": e['sorts'],
          "update_time": e['update_time'],
          "test_type": e['test_type'],
          "option": e['option'],
          "q_group": e['q_group'],
          "test_num": e['test_num'],
          "user": {
            "id": e['user']['id'],
            "name": e['user']['name'],
            "headUrl": e['user']['headUrl'],
            "department": {
              "id": e['user']['department']['id'],
              "name": e['user']['department']['name'],
              "pid": e['user']['department']['pid'],
            }
          }
        });
      }).toList();

      // 刷新页面
      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (tabs.length == 0) {
      return Scaffold(
        body: MyProgress(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("考试排行"),
        actions: [
          FlatButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SelectExam();
                  },
                ),
              );

              print(result);
            },
            child: Text(
              "选择考试",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 基本信息
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左侧用户排名信息
                Container(
                  child: Row(
                    children: [
                      // 排名
                      Text(
                        "第${myExamRankoing.rank}名",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: dp(28.0),
                        ),
                      ),

                      // 头像
                      Container(
                        width: dp(80.0),
                        height: dp(80.0),
                        margin: EdgeInsets.only(left: dp(20.0)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(dp(100.0)),
                          image: DecorationImage(
                            image: NetworkImage(
                              "${myExamRankoing.user.headUrl}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // 用户名称
                      Container(
                        height: dp(80.0),
                        margin: EdgeInsets.only(left: dp(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${myExamRankoing.user.name}",
                              style: TextStyle(
                                fontSize: dp(26.0),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${myExamRankoing.user.department.name}",
                              style: TextStyle(
                                fontSize: dp(22.0),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 右侧得分
                Container(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.yellow[700],
                        fontSize: dp(38.0),
                        fontWeight: FontWeight.w700,
                      ),
                      text: "${(myExamRankoing.fraction).toStringAsFixed(1)}",
                      children: [
                        TextSpan(
                          style: TextStyle(
                            color: Colors.yellow[700],
                            fontSize: dp(26.0),
                          ),
                          text: "分",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 导航栏
          Container(
            color: Colors.white,
            alignment: Alignment.topLeft,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: tabs.map((e) {
                return Tab(
                  text: e.name,
                );
              }).toList(),
            ),
          ),

          // 排行列表
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((e) {
                return ListView.separated(
                  itemCount: rankingList.length,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    ExamRankingDataType item = rankingList[index];

                    String network = rankingList[index].user.headUrl;
                    String asset = "assets/images/account.png";
                    var image = network == ''
                        ? AssetImage(asset)
                        : NetworkImage(network);

                    String rankingInex =
                        index + 1 < 10 ? "0${index + 1}" : index;
                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text("$rankingInex"),
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                width: dp(100.0),
                                height: dp(100.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: image,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              title: Text("${item.user.name}"),
                              subtitle: Text("${item.user.department.name}"),
                              trailing: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.yellow[700],
                                    fontSize: dp(38.0),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  text: "${(item.fraction).toStringAsFixed(1)}",
                                  children: [
                                    TextSpan(
                                      style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: dp(26.0),
                                      ),
                                      text: "分",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// 选择考试
class SelectExam extends StatefulWidget {
  SelectExam({Key key}) : super(key: key);

  @override
  _SelectExamState createState() => _SelectExamState();
}

class _SelectExamState extends State<SelectExam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("请选择一场考试"),
        centerTitle: true,
      ),
    );
  }
}
