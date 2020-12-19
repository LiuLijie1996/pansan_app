import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';
import 'package:pansan_app/models/CertificateDataType.dart'; //证书类型
import 'package:pansan_app/models/IllegalManageDataType.dart'; //三违情况类型
import 'package:pansan_app/models/AdvisoryDataType.dart'; //咨询类型

class TabBarItemDataType {
  int id;
  String title;
  int page;
  int psize;
  int total;
  List data;

  TabBarItemDataType(Map json) {
    id = json['id'];
    title = json['title'];
    page = json['page'];
    psize = json['psize'];
    total = json['total'];
    data = json['data'];
  }
}

//职工服务

class StaffServe extends StatefulWidget {
  @override
  _StaffServeState createState() => _StaffServeState();
}

class _StaffServeState extends State<StaffServe>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TextEditingController _searchInput = TextEditingController(); //搜索框的控制器
  String searchValue; //需要搜索的内容
  TabController _tabController;
  int _tabViewIndex = 0;
  List<TabBarItemDataType> tabBarList = [
    TabBarItemDataType({
      "id": 2,
      "title": "持证情况",
      "page": 1,
      "psize": 20,
      "total": 0,
      "data": [],
    }),
    TabBarItemDataType({
      "id": 3,
      "title": "三违情况",
      "page": 1,
      "psize": 20,
      "total": 0,
      "data": [],
    }),
    TabBarItemDataType({
      "id": 1,
      "title": "咨询",
      "page": 1,
      "psize": 20,
      "total": 0,
      "data": [],
    }),
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);

    // 监听tab栏的变化
    _tabController.addListener(() {
      setState(() {
        _tabViewIndex = _tabController.index;
      });

      var data = tabBarList[_tabViewIndex].data;
      if (data.length == 0) {
        //获取数据
        getTabViewData();
      }
    });

    //获取数据
    getTabViewData();

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 35.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: _searchInput,
            textInputAction: TextInputAction.search,
            //输入框内容变化时触发
            onChanged: (value) {
              searchValue = value;
              // setState(() {});
            },
            //点击键盘上的搜索时触发
            onSubmitted: (value) {
              print(value);
            },
            decoration: InputDecoration(
              hintText: "请输入你要搜索的内容",
              contentPadding: EdgeInsets.only(bottom: 0.0, left: 10.0),
              labelStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.grey[100],
                ),
              ),
              suffixIcon: InkWell(
                child: Icon(
                  Icons.search,
                ),
                onTap: () {
                  print(searchValue);
                },
              ),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabBarList.map((e) {
            return Tab(text: "${e.title}");
          }).toList(),
        ),
      ),
      floatingActionButton: _tabViewIndex == 2
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "/addAdvisory");
              },
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: tabBarList.map((e) {
          var data = e.data;

          if (data.length == 0) {
            return MyProgress();
          }

          return RefreshIndicator(
            // 下拉刷新的回调
            onRefresh: () {
              setState(() {
                tabBarList[_tabViewIndex].data = []; //清空数据
              });
              return getTabViewData(page: 1); //获取数据;
            },
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: data.length + 1,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  var dataItem;

                  // 判断后台是否已经没有数据了
                  if (index == e.total) {
                    return MyProgress(status: false);
                  }

                  try {
                    dataItem = data[index];
                  } catch (err) {
                    //获取数据
                    getTabViewData(page: ++e.page);
                    return MyProgress();
                  }

                  if (_tabViewIndex == 0) {
                    CertificateDataType item =
                        CertificateDataType.fromJson(dataItem);

                    return Container(
                      padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item.name}"),
                          Text("${item.dep}"),
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              print(item);
                            },
                            child: Text(
                              "查看",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (_tabViewIndex == 1) {
                    IllegalManageDataType item =
                        IllegalManageDataType.fromJson(dataItem);
                    //时间
                    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
                      item.addtime * 1000,
                    );
                    // 时间转换
                    var _addtime = formatDate(
                      addtime,
                      [yyyy, '-', mm, '-', dd],
                    );

                    return Container(
                      height: dp(60.0),
                      padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
                      child: InkWell(
                        onTap: () {
                          print(item);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item.title}"),
                            Text("$_addtime"),
                          ],
                        ),
                      ),
                    );
                  }

                  AdvisoryDataType item = AdvisoryDataType.fromJson(dataItem);

                  return Container(
                    height: 30.0,
                    padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
                    child: InkWell(
                      onTap: () {
                        print(item);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item.title}"),
                          Text("${item.addtime}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //获取数据
  getTabViewData({page = 1}) async {
    try {
      var navId = tabBarList[_tabViewIndex].id;
      var psize = tabBarList[_tabViewIndex].psize;

      var result = await myRequest(
        path: '/api/user/getUserServiceList',
        data: {
          "pid": navId,
          "page": page,
          "psize": psize,
        },
      );

      int total = result['total'];
      List data = result['data'];
      List newData = data.map((e) {
        if (_tabViewIndex == 0) {
          // 证书
          return {
            "id": int.parse("${e['id']}"),
            "idCard": e['idCard'],
            "name": e['name'],
            "dep": e['dep'],
            "addtime": int.parse("${e['addtime']}"),
          };
        } else if (_tabViewIndex == 1) {
          // 三违情况
          return {
            "id": int.parse("${e['id']}"),
            "pid": int.parse("${e['pid']}"),
            "title": e['title'],
            "link": e['link'],
            "addtime": int.parse("${e['addtime']}"),
          };
        } else {
          // 咨询
          return {
            "id": int.parse("${e['id']}"),
            "pid": int.parse("${e['pid']}"),
            "title": e['title'],
            "content": e['content'],
            "addtime": int.parse("${e['addtime']}"),
          };
        }
      }).toList();

      if (this.mounted) {
        setState(() {
          if (page == 1) {
            tabBarList[_tabViewIndex].data = [];
          }
          tabBarList[_tabViewIndex].data.addAll(newData);
          //修改分页
          tabBarList[_tabViewIndex].page = page;
          //数据总条数
          tabBarList[_tabViewIndex].total = total;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

// //时间
// DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
//   e['addtime'] * 1000,
// );
// // 时间转换
// String addtime = formatDate(
//   dateTime,
//   [yyyy, '-', mm, '-', dd],
// );
