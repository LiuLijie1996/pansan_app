// 考试排行

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../mixins/withScreenUtil.dart';

class ExamRanking extends StatefulWidget {
  ExamRanking({Key key}) : super(key: key);

  @override
  _ExamRankingState createState() => _ExamRankingState();
}

class _ExamRankingState extends State<ExamRanking>
    with MyScreenUtil, SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller

  List tabs = ["一月一考", '二月一考', '三月一考', '四月一考', '五月一考'];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
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
                        "第1名",
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
                              "https://profile.csdnimg.cn/8/3/6/3_yuzhiqiang_1993",
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
                              "小明",
                              style: TextStyle(
                                fontSize: dp(26.0),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "技术测试部门",
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
                        color: Colors.yellow,
                        fontSize: dp(38.0),
                        fontWeight: FontWeight.w700,
                      ),
                      text: "0.0",
                      children: [
                        TextSpan(
                          style: TextStyle(
                            color: Colors.yellow,
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
                  text: e,
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((e) {
                return Container(
                  child: Text("列表"),
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
