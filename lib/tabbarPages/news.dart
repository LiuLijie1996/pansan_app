import 'package:flutter/material.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';
import 'package:pansan_app/models/NewsDataType.dart';
import 'package:pansan_app/models/NavDataType.dart';

// 新闻页面
class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News>
    with SingleTickerProviderStateMixin, MyScreenUtil {
  TabController _tabController; //需要定义一个Controller
  List<NavDataType> tabs = [];
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
    if (tabs.length == 0) {
      return MyProgress();
    }
    return Scaffold(
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
            return Tab(text: "${item.name}");
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((item) {
          List data = item.data; //导航对应的新闻

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
                        if (data.length < item.total) {
                          int page = ++item.page;
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

                      return NewsCardItem(
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
      var result = await myRequest(path: "/api/news/getNewsItemList");
      List news = result['data'];
      // 遍历新闻导航
      tabs = news.map((item) {
        return NavDataType(
          id: item['id'],
          name: item['name'],
          pid: item['pid'],
          children: item['children'],
          data: [], //用来装新闻的
          page: item['page'], //第几页新闻
          total: item['total'], //新闻总条数
        );
      }).toList();

      // 获取新闻
      this.getNewsList(
        index: 0,
      );

      // 创建Controller
      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(() {
        int index = _tabController.index;
        List data = tabs[index].data;

        // 记录当前显示的 TabBarView
        this._currentIndex = index;

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
    try {
      // 请求数据
      var result = await myRequest(
        path: "/api/news/getIndexNewsList",
        data: {
          "pid": this.tabs[index].id,
          "page": page,
          "psize": psize,
        },
      );

      List data = result['data'];
      int total = result['total'];

      // 遍历获取到的新闻
      List<NewsDataType> newData = data.map((e) {
        return NewsDataType.fromJson(e);
      }).toList();

      if (this.mounted) {
        setState(() {
          // 如果分页从1开始，先清空数组
          if (page == 1) {
            this.tabs[index].data = [];
          }
          this.tabs[index].page = page;
          this.tabs[index].total = total;
          this.tabs[index].data.addAll(newData);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
