import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';

// 新闻页面
class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _tabController; //需要定义一个Controller
  List tabs = [];
  int _currentIndex = 0;

  _NewsState() {
    // 获取头部tabBar
    this.getTopTabBar();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    // var accentColor = theme.accentColor; //主题色
    // var textColor =
    //     accentColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    return tabs.length == 0
        ? Container()
        : Scaffold(
            appBar: AppBar(
              title: Text("新闻列表"),
              centerTitle: true,
              bottom: TabBar(
                //生成Tab菜单
                controller: _tabController,
                isScrollable: tabs.length >= 4,
                onTap: (int index) {
                  print("Tab菜单变动了：$index");
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

                if (data.length == 0) {
                  return MyProgress();
                }

                // 下拉刷新
                return RefreshIndicator(
                  // 下拉刷新的回调
                  onRefresh: () {
                    return getNewsList(index: _currentIndex, page: 1);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            // 判断是否需要请求数据
                            if (index == data.length - 1) {
                              // 判断后台是否还有数据
                              if (data.length < item['total']) {
                                int page = ++item['page'];
                                // 请求数据
                                this.getNewsList(
                                  index: _currentIndex,
                                  page: page,
                                );

                                return MyProgress();
                              } else {
                                return MyProgress(status: false);
                              }
                            }

                            return CardItem(
                              item: data[index],
                              onClick: () {
                                print(data[index]);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );
  }

  // 获取头部tabBar
  getTopTabBar() async {
    try {
      var result = await myRequest(path: "/api/nav/nav-all");
      List news = result['data']['news'];
      // 遍历新闻导航
      List newsList = news.map((item) {
        List children = item['children'] ?? [];
        return {
          "id": item['id'],
          "name": item['name'],
          "pid": item['pid'],
          "children": children.map(
            (child) {
              return {
                "id": child["id"],
                "name": child["name"],
                "pid": child['pid'],
              };
            },
          ).toList(),
          "data": [], //用来装新闻的
          "page": 1, //第几页新闻
          "total": 0, //新闻总条数
        };
      }).toList();

      setState(() {
        tabs = newsList;
      });

      // 获取新闻
      this.getNewsList(
        index: 0,
      );

      // 创建Controller
      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(() {
        int index = _tabController.index;
        List data = this.tabs[index]['data'];

        setState(() {
          // 记录当前显示的 TabBarView
          this._currentIndex = index;
        });

        // 获取新闻
        if (data.length == 0) {
          this.getNewsList(
            index: index,
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // 获取新闻列表
  getNewsList({
    @required index,
    int page = 1,
    int psize = 20,
  }) async {
    // 找到对应的tab
    var tabItem = this.tabs.firstWhere((item) {
      return item['id'] == this.tabs[index]['id'];
    });

    try {
      // 请求数据
      var result = await myRequest(
        path: "/api/news/newsList",
        data: {
          "pid": tabItem['id'],
          "page": page,
          "psize": psize,
        },
      );

      List data = result['data'];
      int total = result['total'];

      // 遍历获取到的新闻
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
          "id": item['id'], //id
          "thumb_url": item['thumb_url'], //封面图
          "type": item['type'], //类型：1图文，2视频
          "title": item['title'], //标题
          "addtime": addtime, //发布时间
          "view_num": item['view_num'], //观看人数
        };
      }).toList();

      setState(() {
        // 如果分页从1开始，先清空数组
        if (page == 1) {
          this.tabs[index]['data'] = [];
        }
        print("分页：$page");
        this.tabs[index]['page'] = page;
        this.tabs[index]['total'] = total;
        this.tabs[index]['data'].addAll(mapData);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
