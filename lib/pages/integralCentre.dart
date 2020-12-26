import 'package:flutter/material.dart';
import '../mixins/withScreenUtil.dart';

// 积分中心页面
class IntegralCentre extends StatefulWidget {
  IntegralCentre({Key key}) : super(key: key);

  @override
  _IntegralCentreState createState() => _IntegralCentreState();
}

class _IntegralCentreState extends State<IntegralCentre>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _tabController; //需要定义一个Controller
  List tabs = [
    {
      "title": '积分明细',
      "router": '/integralDetail',
    },
    {
      "title": '兑换记录',
      "router": '/integralDetail',
    },
    {
      "title": '积分规则',
      "router": '/integralDetail',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // pinned: true,
            title: Text('积分中心'),
            expandedHeight: dp(400.0),
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                height: dp(160.0),
                child: Column(
                  children: [
                    Text(
                      "100",
                      style: TextStyle(
                        fontSize: dp(50.0),
                      ),
                    ),
                    Text(
                      "可用积分",
                      style: TextStyle(
                        fontSize: dp(26.0),
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Image.asset(
                'assets/images/jifen_center_bg.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            bottom: TabBar(
              //生成Tab菜单
              controller: _tabController,
              tabs: tabs.map((e) {
                return InkWell(
                  child: Tab(
                    child: Text(
                      "${e['title']}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "${e['router']}");
                  },
                );
              }).toList(),
            ),
          ),
          SliverList(
            // 构建代理
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.red[index % 10 * 100],
                  child: Text("SliverList $index"),
                );
              },
              // 指定子元素的个数
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
