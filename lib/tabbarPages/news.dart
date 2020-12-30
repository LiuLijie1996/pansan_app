import 'package:flutter/material.dart';
import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';
import 'package:pansan_app/models/NewsDataType.dart';
import 'package:pansan_app/models/NavDataType.dart';
import 'package:pansan_app/components/EmptyBox.dart';

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
        children: tabs.map((tabItem) {
          var data = tabItem.data; //导航对应的新闻

          // 下拉刷新
          return RefreshIndicator(
            // 下拉刷新的回调
            onRefresh: () {
              return getNewsList(index: _currentIndex, page: 1);
            },
            child: Column(
              children: [
                Expanded(
                  child: data == null
                      ? MyProgress()
                      : data.length == 0
                          ? EmptyBox()
                          : ListView.builder(
                              itemCount: data.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                var item;

                                // 判断后台是否还有数据
                                if (index == tabItem.total) {
                                  return MyProgress(status: false);
                                }

                                try {
                                  item = tabItem.data[index];
                                } catch (err) {
                                  print("报错信息：$err");
                                  // 请求数据
                                  this.getNewsList(
                                    index: _currentIndex,
                                    page: ++tabItem.page,
                                  );

                                  return MyProgress();
                                }

                                try {
                                  NewsDataType dataItem =
                                      NewsDataType.fromJson(item);
                                  return NewsCardItem(
                                    item: dataItem,
                                    onClick: () {
                                      print(dataItem);
                                    },
                                  );
                                } catch (err) {
                                  return Text("$err");
                                }
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
      var result =
          await myRequest(context: context, path: MyApi.getNewsItemList);
      List news = result['data'];
      // 遍历新闻导航
      tabs = news.map((item) {
        return NavDataType(
          id: item['id'],
          name: item['name'],
          pid: item['pid'],
          children: item['children'],
          data: null, //用来装新闻的
          page: 1, //第几页新闻
          total: null, //新闻总条数
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
        var data = tabs[index].data;

        // 记录当前显示的 TabBarView
        this._currentIndex = index;

        // 获取新闻
        if (data == null) {
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
        context: context,
        path: MyApi.newsList,
        data: {
          "pid": this.tabs[index].id,
          "page": page,
          "psize": psize,
        },
      );

      List data = result['data'];
      int total = result['total'];

      // 遍历获取到的新闻
      List newData = data.map((e) {
        return {
          "id": e['id'], //新闻id
          "pid": e['pid'], //导航id
          "title": e['title'], //标题
          "desc": e['desc'], //简介
          "thumb_url": e['thumb_url'], //封面
          "type": e['type'], //新闻类型 1图文  2视频
          "materia_id": e['materia_id'], //资源id
          "content": e['content'], //文章内容
          "tuij": e['tuij'], //是否推荐 0不推荐 1推荐
          "addtime": e['addtime'], //新闻添加时间
          "view_num": e['view_num'], //观看次数
          "upvote": e['upvote'], //点赞个数
          "materia": e['materia'], //视频链接
          "newsImgText": e['newsImgText'], //阅读图文有效时间：1000字60秒
          "newsVideo": e['newsVideo'], //视频有效观看时间 单位：秒
          "collect": e['collect'], //是否收藏
        };
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
