import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/utils/myRequest.dart';

// 学习页面
class Study extends StatefulWidget {
  Study({Key key}) : super(key: key);

  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study> with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个tab的Controller
  TextEditingController _searchInput = TextEditingController(); //搜索框的控制器
  String searchValue; //需要搜索的内容
  List tabs = [];
  int _currentIndex = 0;
  var _currentNavId; //当前导航id

  @override
  void initState() {
    print("生命周期：initState");
    // TODO: implement initState
    super.initState();

    // 获取头部tabBar
    this.getTopTabBar();

    // 监听搜索框的变化
    // _searchInput.addListener(() {
    //   print(_searchInput.text);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var accentColor = theme.accentColor; //主题色
    var textColor =
        accentColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    return tabs.length == 0
        ? Container()
        : Scaffold(
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
                  onChanged: (String value) {
                    setState(() {
                      searchValue = value;
                    });
                  },
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
                //生成Tab菜单
                controller: _tabController,
                isScrollable: tabs.length >= 4,
                onTap: (int index) {
                  print("Tab菜单被点击了：$index");
                },
                tabs: tabs.map((item) {
                  return Tab(text: "${item['name']}");
                }).toList(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: tabs.map((item) {
                List data = item['data']; //导航对应的新闻
                List children = item["children"]; //子导航
                // 下拉刷新
                return RefreshIndicator(
                  // 下拉刷新的回调
                  onRefresh: () {
                    return Future.delayed(Duration(seconds: 2)).then((value) {
                      this.getCourseList(id: _currentNavId, page: 1);
                    });
                  },
                  child: Column(
                    children: [
                      // 子导航
                      children.length == 0
                          ? Container()
                          : Container(
                              alignment: Alignment.topLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: children.map((child) {
                                    double right =
                                        child == children[children.length - 1]
                                            ? 10.0
                                            : 0;
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: right),
                                      child: RaisedButton(
                                        color: accentColor,
                                        textColor: textColor,
                                        onPressed: () {
                                          setState(() {
                                            // 清空之前的数据
                                            tabs[_currentIndex]['data'] = [];
                                          });

                                          // 请求子导航对应的数据
                                          Future.delayed(Duration(seconds: 2))
                                              .then((value) {
                                            this.getCourseList(
                                              id: child['id'],
                                              page: 1,
                                            );
                                          });
                                        },
                                        child: Text("${child['name']}"),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                      // 列表
                      Expanded(
                        // 判断是否有数据
                        child: tabs[_currentIndex]['data'].length != 0
                            ? ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // 判断是否需要请求数据
                                  if (index == data.length - 1) {
                                    // 判断后台是否还有数据
                                    if (data.length < item['total']) {
                                      Future.delayed(Duration(seconds: 2))
                                          .then((value) {
                                        this.getCourseList(
                                          id: _currentNavId,
                                          page: item['page'] + 1,
                                        );
                                      });

                                      return AspectRatio(
                                        aspectRatio: 16 / 1.5,
                                        child: Container(
                                          color: Colors.white,
                                          child: UnconstrainedBox(
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                              ), //环形进度器
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return AspectRatio(
                                        aspectRatio: 16 / 1.5,
                                        child: Container(
                                          color: Colors.white,
                                          alignment: Alignment.center,
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

                                  return CardItem(
                                    item: data[index],
                                    onClick: (item) {
                                      print(item);
                                    },
                                  );
                                },
                              )
                            : Center(
                                child: AspectRatio(
                                  aspectRatio: 16 / 1.5,
                                  child: Container(
                                    child: UnconstrainedBox(
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ), //环形进度器
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );
  }

  // 获取头部tabbar
  getTopTabBar() async {
    try {
      var result = await myRequest(path: "/api/nav/nav-all");
      List courseNavList = result['data']['courseNavList'];
      // 遍历课程导航
      List courseList = courseNavList.map((item) {
        // 获取子导航
        List children = item['children'] ?? [];
        return {
          "id": item['id'],
          "name": item['name'],
          "pid": item['pid'],
          "children": children.map((child) {
            return {
              "id": child["id"],
              "name": child["name"],
              "pid": child['pid'],
            };
          }).toList(),
          "data": [], //用来装课程的
          "page": 1, //第几页新闻
          "total": 0, //课程总条数
        };
      }).toList();

      setState(() {
        tabs = courseList;
      });

      // 获取课程
      this.getCourseList(
        id: courseList[0]['id'],
        page: courseList[0]['page'],
      );

      // 创建Controller
      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(() {
        int index = _tabController.index;
        List data = this.tabs[index]['data'];

        setState(() {
          // 记录当前显示的 TabBarView
          this._currentIndex = index;
          // 记录当前tab对应的id
          this._currentNavId = this.tabs[index]['id'];
        });

        // 获取课程
        if (data.length == 0) {
          this.getCourseList(
            id: courseList[index]['id'],
            page: 1,
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // 获取课程
  getCourseList({
    @required id, //获取课程时需要的导航id
    @required int page, //分页
    psize = 20, //每页多少数据
  }) async {
    try {
      var result = await myRequest(path: "/api/course/courseList", data: {
        "pid": id,
        "page": page,
        "psize": psize,
      });
      List data = result['data']; //获取到的列表数据
      int total = result['total']; //列表总个数

      // 遍历获取到的课程
      List mapData = data.map((item) {
        //时间
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          item['addtime'] * 1000,
        );
        // 时间转换
        String addtime = formatDate(
          dateTime,
          [yyyy, '-', mm, '-', dd],
        );

        return {
          "id": item['course']['id'], //id
          "thumb_url": item['thum_url'], //封面图
          "status": item['status'], //1已学完 2未学习 3学习中
          "title": item['name'], //标题
          "addtime": addtime, //发布时间
          "view_num": item['view_num'], //观看人数
        };
      }).toList();

      setState(() {
        // 如果分页从1开始，先清空数组
        if (page == 1) {
          this.tabs[this._currentIndex]['data'] = [];
        }
        print("记录当前数据对应的导航id: $id");
        this._currentNavId = id; //记录当前数据对应的导航id
        this.tabs[this._currentIndex]['page'] = page; //记录当前导航对应的分页
        this.tabs[this._currentIndex]['total'] = total; //记录当前导航对应的总个数
        this.tabs[this._currentIndex]['data'].addAll(mapData); //记录当前导航对应的数据
      });
    } catch (e) {
      print(e);
    }
  }
}
