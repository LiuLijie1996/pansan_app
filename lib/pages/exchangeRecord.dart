// 兑换记录

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/GoodsExchangeDataType.dart';
import '../utils/ErrorInfo.dart';

class ExchangeRecord extends StatefulWidget {
  ExchangeRecord({Key key}) : super(key: key);

  @override
  _ExchangeRecordState createState() => _ExchangeRecordState();
}

class _ExchangeRecordState extends State<ExchangeRecord> with MyScreenUtil {
  List<GoodsExchangeDataType> goodsExchangeList = [];
  int total = 0; //总个数
  int page = 1; //分页

  @override
  void initState() {
    super.initState();

    // 获取兑换记录
    getGoodsExchangeList();
  }

  // 获取兑换记录
  getGoodsExchangeList({
    page = 1,
  }) async {
    try {
      var result = await myRequest(
        context: context,
        path: MyApi.getUserScoreExchange,
        data: {
          "user_id": 1,
          "page": page,
          "psize": 20,
        },
      );
      total = result['total'];
      List data = result['data'];
      List<GoodsExchangeDataType> newData = data.map((e) {
        return GoodsExchangeDataType.fromJson({
          "id": e['id'],
          "d_id": e['d_id'],
          "user_id": e['user_id'],
          "goods_id": e['goods_id'],
          "score": e['score'],
          "addtime": e['addtime'],
          "status": e['status'],
          "update_time": e['update_time'],
          "goods": {
            "id": e['goods']['id'],
            "name": e['goods']['name'],
            "thumb_url": e['goods']['thumb_url'],
            "score": e['goods']['score'],
            "num": e['goods']['num'],
            "addtime": e['goods']['addtime'],
            "status": e['goods']['status'],
            "exchange": e['goods']['exchange']
          },
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          if (page == 1) {
            goodsExchangeList = [];
          }

          goodsExchangeList.addAll(newData);
        });
      }
    } catch (e) {
      ErrorInfo(
        context: context,
        errInfo: e,
        msg: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (goodsExchangeList.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("兑换记录"),
          centerTitle: true,
        ),
        body: EmptyBox(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("兑换记录"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: goodsExchangeList.length + 1,
        itemBuilder: (context, index) {
          // 判断后台有没有数据了
          if (index == total) {
            return MyProgress(status: false);
          }
          GoodsExchangeDataType item;
          try {
            item = goodsExchangeList[index];
          } catch (e) {
            // 如果报错了，说明要请求数据了
            getGoodsExchangeList(page: ++this.page);

            return MyProgress();
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
            child: ExchangeItemWidget(
              exchangeInfo: item,
            ),
          );
        },
      ),
    );
  }
}

// 兑换信息组件
class ExchangeItemWidget extends StatelessWidget with MyScreenUtil {
  GoodsExchangeDataType exchangeInfo; //兑换信息
  ExchangeItemWidget({Key key, @required this.exchangeInfo}) : super(key: key);

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
                  "${exchangeInfo.goods.thumbUrl}",
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
                  child: Text("${exchangeInfo.goods.name}"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${exchangeInfo.score}积分"),
                    SizedBox(
                      height: dp(60.0),
                      child: RaisedButton(
                        onPressed: null,
                        color: Colors.blue,
                        disabledColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          exchangeInfo.status == 1 ? "已审核" : "审核中",
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
