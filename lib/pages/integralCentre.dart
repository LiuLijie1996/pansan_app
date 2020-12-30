import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/MyProgress.dart';
import '../utils/myRequest.dart';
import '../mixins/withScreenUtil.dart';
import '../models/GoodsDataType.dart';

// 积分中心页面
class IntegralCentre extends StatefulWidget {
  IntegralCentre({Key key}) : super(key: key);

  @override
  _IntegralCentreState createState() => _IntegralCentreState();
}

class _IntegralCentreState extends State<IntegralCentre>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _tabController; //需要定义一个Controller
  List<GoodsDataType> goodsList = []; //商品列表
  int total = 0; //商品总数量
  int page = 1; //分页
  List tabs = [
    {
      "title": '积分明细',
      "router": '/integralDetail',
    },
    {
      "title": '兑换记录',
      "router": '/exchangeRecord',
    },
    {
      "title": '积分规则',
      "router": '/integralRule',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);

    // 获取商品列表
    getGoodsList();
  }

  // 获取商品列表
  getGoodsList({
    page = 1,
  }) async {
    try {
      var result = await myRequest(
        context: context,
        path: MyApi.goodsList,
        data: {
          "page": page,
          "psize": 20,
        },
      );

      List data = result['data'];
      total = result['total'];
      List<GoodsDataType> newData = data.map((e) {
        return GoodsDataType.fromJson({
          "id": e['id'],
          "name": e['name'],
          "thumb_url": e['thumb_url'],
          "score": e['score'],
          "num": e['num'],
          "addtime": e['addtime'],
          "status": e['status'],
          "exchange": e['exchange']
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          if (page == 1) {
            goodsList = [];
          }
          goodsList.addAll(newData);
        });
      }
    } catch (e) {
      print(e);
    }
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
              onTap: (int index) {
                var e = tabs[index];
                Navigator.pushNamed(context, "${e['router']}");
              },
              tabs: tabs.map((e) {
                return Tab(
                  child: Text(
                    "${e['title']}",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
          SliverList(
            // 构建代理
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // 判断后台有没有数据了
                if (index == total) {
                  return MyProgress(status: false);
                }

                GoodsDataType goodsItem;
                try {
                  goodsItem = goodsList[index];
                } catch (e) {
                  // 如果报错了说明需要请求数据了
                  getGoodsList(page: ++this.page);

                  return MyProgress();
                }

                return Container(
                  padding: EdgeInsets.all(dp(20.0)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  child: GoodsItemWidget(goodsItem: goodsItem),
                );
              },
              // 指定子元素的个数
              childCount: goodsList.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}

// 商品列表
class GoodsItemWidget extends StatelessWidget with MyScreenUtil {
  GoodsDataType goodsItem; //商品
  GoodsItemWidget({Key key, @required this.goodsItem}) : super(key: key);

  // 点击兑换时弹窗提示
  showToast(context) async {
    try {
      // 请求后台进行兑换
      var result = await myRequest(
        context: context,
        path: MyApi.userExchangeScore,
        data: {
          "user_id": true,
          "goods_id": goodsItem.id,
          "score": goodsItem.score,
        },
      );

      Fluttertoast.showToast(
        msg: "${result['msg']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 5,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(dp(20.0)),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  "${goodsItem.thumbUrl}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: dp(20.0)),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  child: Text("${goodsItem.name}"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${goodsItem.score}积分"),
                    SizedBox(
                      height: dp(60.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        onPressed: () {
                          showToast(context);
                        },
                        child: Text(
                          "兑换",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
