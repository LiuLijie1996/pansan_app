import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/utils/myRequest.dart';

//职工服务

class StaffServe extends StatefulWidget {
  @override
  _StaffServeState createState() => _StaffServeState();
}

class _StaffServeState extends State<StaffServe>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchInput = TextEditingController(); //搜索框的控制器
  String searchValue; //需要搜索的内容
  TabController _tabController;
  int _tabViewIndex = 0;
  List<Map> tabBarList = [
    {
      "id": "2",
      "title": "持证情况",
      "page": 1,
      "psize": 20,
      "total": 0,
      "data": [
        // {
        //   "id":"1",
        //   "idCard":"123456",
        //   "name":"小明",
        //   "dep":"掘进队",
        // }
      ],
    },
    {
      "id": "3",
      "title": "三违情况",
      "page": 1,
      "psize": 20,
      "total": 0,
      "data": [
        // {
        //   "id":"1",
        //   "pid":"2",
        //   "title":"标题",
        //   "addtime":"2020-01-01",
        //   "link":"",
        // }
      ],
    },
    {
      "id": "1",
      "title": "咨询",
      "page": 1,
      "psize": 20,
      "total": 0,
      "data": [
        // {
        //   "id":"1",
        //   "pid":"2",
        //   "title":"标题",
        //   "content":"内容内容内容内容",
        //   "addtime":"2020-01-01",
        // }
      ],
    },
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);

    _tabController.addListener(() {
      print("tabView下标：${_tabController.index}");
      setState(() {
        _tabViewIndex = _tabController.index;
      });
      if (tabBarList[_tabViewIndex]['data'].length == 0) {
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
            onChanged: (String value) {
              setState(() {
                searchValue = value;
              });
            },
            //点击键盘上的搜索时触发
            onSubmitted: (String value) {
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
            return Tab(text: "${e['title']}");
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabBarList.map((e) {
          List data = e['data'];

          if (data.length == 0) {
            return UnconstrainedBox(
              child: Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(), //环形进度器
              ),
            );
          }

          return RefreshIndicator(
            // 下拉刷新的回调
            onRefresh: () {
              return Future.delayed(Duration(seconds: 2)).then((value) {
                setState(() {
                  tabBarList[_tabViewIndex]['data'] = []; //清空数据
                  getTabViewData(page: 1); //获取数据
                });
              });
            },
            child: Container(
              color:Colors.white,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  Map item = data[index];
                  int dataLength = data.length;
                  int total = e['total'];
                  //判断是否滚动到底部了
                  if (dataLength == index + 1) {
                    //判断后端是否还有数据
                    if (dataLength < total) {
                      Future.delayed(Duration(milliseconds: 2000))
                          .then((value) {
                        //获取数据
                        getTabViewData(page: ++e['page']);
                      });

                      return UnconstrainedBox(
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(bottom: 10),
                          child: CircularProgressIndicator(), //环形进度器
                        ),
                      );
                    } else {
                      return UnconstrainedBox(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "没有更多数据了...",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  if (_tabViewIndex == 0) {
                    return Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item['name']}"),
                          Text("${item['dep']}"),
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
                    return Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: InkWell(
                        onTap: () {
                          print(item);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item['title']}"),
                            Text("${item['addtime']}"),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    height: 30.0,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: InkWell(
                      onTap: () {
                        print(item);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item['title']}"),
                          Text("${item['addtime']}"),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: data.length,
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
      String navId = tabBarList[_tabViewIndex]['id'];
      int psize = tabBarList[_tabViewIndex]['psize'];

      var result = await myRequest(
        path: '/api/staff-serve',
        data: {
          "user_id": "用户id",
          "pid": navId,
          "page": page,
          "psize": psize,
        },
      );

      List data = result['data'];
      int total = result['total'];

      List newData = data.map((e) {
        if (_tabViewIndex == 0) {
          return {
            "id": e['id'],
            "idCard": e['idCard'],
            "name": e['name'],
            "dep": e['dep'],
          };
        } else if (_tabViewIndex == 1) {
          //时间
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            e['addtime'] * 1000,
          );
          // 时间转换
          String addtime = formatDate(
            dateTime,
            [yyyy, '-', mm, '-', dd],
          );

          return {
            "id": e['id'],
            "pid": e['pid'],
            "title": e['title'],
            "link": e['link'],
            "addtime": addtime,
          };
        } else {
          //时间
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            e['addtime'] * 1000,
          );
          // 时间转换
          String addtime = formatDate(
            dateTime,
            [yyyy, '-', mm, '-', dd],
          );

          return {
            "id": e['id'],
            "pid": e['pid'],
            "title": e['title'],
            "content": e['content'],
            "addtime": addtime,
          };
        }
      }).toList();

      setState(() {
        //修改分页
        tabBarList[_tabViewIndex]['page'] = page;
        //数据总条数
        tabBarList[_tabViewIndex]['total'] = total;
        //将数据添加到数组中
        tabBarList[_tabViewIndex]['data'].addAll(newData);
      });
    } catch (e) {
      print(e);
    }
  }
}
