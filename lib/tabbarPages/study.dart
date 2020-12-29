import 'package:flutter/material.dart';
import '../components/CardItem.dart';
import '../components/MyProgress.dart';
import '../components/EmptyBox.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/CourseDataType.dart';
import '../models/NavDataType.dart';
import '../components/MyIcon.dart';

// 学习页面
class Study extends StatefulWidget {
  Study({Key key}) : super(key: key);

  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _tabController; //需要定义一个tab的Controller
  List<NavDataType> tabs = [];
  int _currentIndex = 0;
  var _currentNavId; //当前导航id

  _StudyState() {
    // 获取头部tabBar
    this.getTopTabBar();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // 获取头部tabbar
  getTopTabBar() async {
    try {
      var result = await myRequest(path: "/api/course/getCourseItemList");
      List courseNavList = result['data'];
      // 遍历课程导航
      tabs = courseNavList.map((item) {
        List children = item['children'] ?? [];
        return NavDataType(
          id: item['id'],
          name: item['name'],
          pid: item['pid'],
          children: children.map((e) {
            return Children.fromJson(e);
          }).toList(),
          data: null, //用来装课程的
          page: 1, //第几页课程
          total: null, //课程总条数
        );
      }).toList();

      // 获取课程
      this.getCourseList(
        id: tabs[0].id,
        page: tabs[0].page,
      );

      // 创建Controller
      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(() {
        setState(() {});

        int index = _tabController.index;
        var data = this.tabs[index].data;

        // 记录当前显示的 TabBarView
        this._currentIndex = index;
        // 记录当前tab对应的id
        this._currentNavId = this.tabs[index].id;

        // 获取课程
        if (data == null) {
          this.getCourseList(
            id: tabs[index].id,
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
        "user_id": 1,
        "pid": id,
        "page": page,
        "psize": psize,
      });
      List data = result['data']; //获取到的列表数据
      int total = result['total']; //列表总个数

      // 遍历获取到的课程
      List newData = data.map((e) {
        return {
          "id": e['id'], //课程id
          "pid": e['pid'], //导航id
          "name": e['name'], //标题
          "desc": e['desc'], //简介
          "content": e['content'], //课程介绍
          "addtime": e['addtime'], //添加时间
          "thumb_url": e['thumb_url'], //封面
          "study_status": e['study_status'], //学习状态 1已学完 2未学习 3学习中
          "chapter": e['chapter'].map((ele) {
            return {
              "id": ele['id'], //章节id
              "d_id": ele['d_id'], //部门id
              "pid": ele['pid'], //分类id
              "name": ele['name'], //章节名称
              "addtime": ele['addtime'], //添加时间
            };
          }).toList(),
          "view_num": e['view_num'] //在学人数
        };
      }).toList();

      if (this.mounted) {
        // 刷新页面
        setState(() {
          // 如果分页从1开始，先清空数组
          if (page == 1) {
            this.tabs[this._currentIndex].data = [];
          }
          this._currentNavId = id; //记录当前数据对应的导航id
          this.tabs[this._currentIndex].page = page; //记录当前导航对应的分页
          this.tabs[this._currentIndex].total = total; //记录当前导航对应的总个数
          this.tabs[this._currentIndex].data.addAll(newData); //记录当前导航对应的数据
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var accentColor = theme.accentColor; //主题色
    var textColor =
        accentColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    if (tabs.length == 0) {
      return MyProgress();
    }

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            // 跳转到搜索页
            Navigator.pushNamed(context, "/searchPage");
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: dp(10.0),
              bottom: dp(10.0),
              left: dp(10.0),
              right: dp(10.0),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(dp(10.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "请输入你要搜索的内容",
                  style: TextStyle(color: Colors.grey, fontSize: dp(32.0)),
                ),
                Icon(
                  Icons.search,
                  color: Colors.black54,
                  // size: dp(30.0),
                )
              ],
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
            return Tab(text: "${item.name}");
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((tabItem) {
          var data = tabItem.data; //导航对应的新闻
          List<Children> children = tabItem.children; //子导航

          // 下拉刷新
          return RefreshIndicator(
            // 下拉刷新的回调
            onRefresh: () {
              return getCourseList(id: _currentNavId, page: 1);
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
                                      ? dp(20.0)
                                      : 0;
                              return Container(
                                margin: EdgeInsets.only(
                                  left: dp(20.0),
                                  right: right,
                                ),
                                child: RaisedButton(
                                  color: accentColor,
                                  textColor: textColor,
                                  onPressed: () {
                                    setState(() {
                                      // 清空之前的数据
                                      tabs[_currentIndex].data = [];
                                    });

                                    // 请求子导航对应的数据
                                    this.getCourseList(
                                      id: child.id,
                                      page: 1,
                                    );
                                  },
                                  child: Text("${child.name}"),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                // 列表
                Expanded(
                  // 判断是否有数据
                  child: data == null
                      ? MyProgress()
                      : data.length == 0
                          ? EmptyBox()
                          : ListView.builder(
                              itemCount: data.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                var item;
                                if (index == tabItem.total) {
                                  return MyProgress(status: false);
                                }

                                try {
                                  item = data[index];
                                } catch (err) {
                                  // 请求数据
                                  this.getCourseList(
                                    id: _currentNavId,
                                    page: tabItem.page + 1,
                                  );
                                  return MyProgress();
                                }

                                try {
                                  CourseDataType courseItem =
                                      CourseDataType.fromJson(item);
                                  return CourseCardItem(
                                    item: courseItem,
                                    onClick: () {
                                      print("${courseItem.toJson()}");
                                    },
                                  );
                                } catch (err) {
                                  return Text("$err");
                                }
                              },
                            ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
