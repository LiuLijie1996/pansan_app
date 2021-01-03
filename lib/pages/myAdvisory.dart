import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/EmptyBox.dart';
import '../components/MyProgress.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';
import '../models/AdvisoryDataType.dart';

/// 我的咨询
class MyAdvisory extends StatefulWidget {
  MyAdvisory({Key key}) : super(key: key);

  @override
  _MyAdvisoryState createState() => _MyAdvisoryState();
}

class _MyAdvisoryState extends State<MyAdvisory> with MyScreenUtil {
  int total = 0;
  int page = 1;
  int psize = 20;
  List<AdvisoryDataType> dataList = [];
  //初始化是否完成
  bool isInitialize = false;

  @override
  void initState() {
    super.initState();

    // 请求数据
    getAdvisoryData();
  }

  // 请求数据
  getAdvisoryData({page = 1}) async {
    try {
      var result = await myRequest(
        path: MyApi.getUserServiceList,
        data: {
          "user_id": true,
          "pid": 1,
          "page": page,
          "psize": psize,
        },
      );

      total = result['total'];
      List data = result['data'];
      List<AdvisoryDataType> newData = data.map((e) {
        return AdvisoryDataType.fromJson({
          "id": e['id'],
          "pid": e['pid'],
          "title": e['title'],
          "content": e['content'],
          "addtime": e['addtime'],
        });
      }).toList();

      setState(() {
        isInitialize = true;
        if (page == 1) {
          // 清空数据
          dataList = [];
        }

        dataList.addAll(newData);
      });
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取我的咨询失败",
        path: MyApi.getUserServiceList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialize) {
      return Scaffold(
        body: MyProgress(),
      );
    }

    if (total == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("我的咨询"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/addAdvisory");
          },
        ),
        body: EmptyBox(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("我的咨询"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/addAdvisory");
        },
      ),
      body: RefreshIndicator(
        // 下拉刷新
        onRefresh: () {
          return getAdvisoryData(page: 1);
        },
        child: Container(
          padding: EdgeInsets.only(top: dp(10.0)),
          color: Colors.white,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: dataList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              AdvisoryDataType item;
              String addtime;

              try {
                item = dataList[index];

                DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  item.addtime * 1000,
                );
                // 时间转换
                addtime = formatDate(
                  dateTime,
                  [yyyy, '-', mm, '-', dd],
                );
              } catch (e) {
                // 如果报错了说明要请求数据了

                // 判断后台有没有数据了
                if (dataList.length == total) {
                  // 没有数据了
                  return MyProgress(
                    status: false,
                    padding: EdgeInsets.only(top: 0.0, bottom: dp(20.0)),
                  );
                }

                // 继续请求数据
                getAdvisoryData(page: ++page);
                return MyProgress(
                  padding: EdgeInsets.only(top: 0.0, bottom: dp(20.0)),
                );
              }

              return InkWell(
                onTap: () {
                  // 跳转到咨询详情
                  Navigator.pushNamed(
                    context,
                    '/advisoryDetail',
                    arguments: item,
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: dp(20.0),
                    right: dp(20.0),
                    top: dp(30.0),
                    bottom: dp(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item.title}"),
                      Text("$addtime"),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
