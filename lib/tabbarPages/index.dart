import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'package:pansan_app/components/CardItem.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/tabbarPages/MyBottomNavigationBar.dart';
import '../components/MyIcon.dart';
import '../components/MyTags.dart';
import '../utils/myRequest.dart';

// 首页页面
class Index extends StatefulWidget {
  Index({Key key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("职工学习平台"),
        actions: [
          UnconstrainedBox(
            child: Container(
              // width: 35.0,
              // height: 35.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: IconButton(
                onPressed: () {
                  scan();
                },
                icon: Icon(myIcon['sao']),
              ),
            ),
          ),
          UnconstrainedBox(
            child: Container(
              // width: 35.0,
              // height: 35.0,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: IconButton(
                onPressed: () {
                  // 跳转到积分中心
                  Navigator.pushNamed(context, "/integralCentre");
                },
                icon: Icon(myIcon['jifen']),
              ),
            ),
          ),
        ],
      ),
      // 主体内容
      body: IndexPage(),
    );
  }

  Future scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      String barcode = await BarcodeScanner.scan();
      print('扫码结果: ' + barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException {
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }
}

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  int _totalLength = 0;
  List<dynamic> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 请求数据
    isRequestList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: CustomScrollView(
        slivers: [
          // 轮播图
          SliverToBoxAdapter(
            child: MyBanner(),
          ),

          // 快捷导航
          SliverToBoxAdapter(
            child: FastNavList(),
          ),

          // 最新考试
          SliverToBoxAdapter(
            child: NewestTest(),
          ),

          // 资讯
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                child: Column(
                  children: [
                    // 头部标题
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("矿井动态");
                                setState(() {
                                  this.list = [];
                                  _currentIndex = 0;
                                });
                                // 请求数据
                                this.isRequestList();
                              },
                              child: Text(
                                "矿井动态",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == 0
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                print("最新课程");
                                setState(() {
                                  this.list = [];
                                  _currentIndex = 1;
                                });
                                // 请求数据
                                this.isRequestList();
                              },
                              child: Text(
                                "最新课程",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == 1
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Text("查看更多 >"),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (
                                  BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  //  FadeTransition 淡入淡出组件
                                  return FadeTransition(
                                    opacity: animation,
                                    child: MyBottomNavigationBar(
                                      currentIndex: _currentIndex == 0 ? 1 : 2,
                                    ),
                                  );
                                },
                              ),
                              (route) => route == null, //将所有路由清空
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // MyInformation(currentIndex: _currentIndex),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              _currentIndex == 0 ? list1Widget : list2Widget,
              childCount: list.length,
            ),
          ),
        ],
      ),
    );
  }

  // 矿井动态对应的数据展示
  Widget list1Widget(BuildContext context, int index) {
    var item = list[index];

    // 判断是否需要请求数据
    if (index == list.length - 1) {
      // 判断后端是否还有数据
      if (list.length - 1 < _totalLength) {
        // 请求数据
        isRequestList();

        return MyProgress();
      } else {
        return MyProgress(status: false);
      }
    }

    return CardItem(
      item: item,
      onClick: () {
        print(item);
      },
    );
  }

  // 最新课程对应的数据展示
  Widget list2Widget(BuildContext context, int index) {
    var item = list[index];

    // 判断是否需要请求数据
    if (index == list.length - 1) {
      // 判断后端是否还有数据
      if (list.length - 1 < _totalLength) {
        // 请求数据
        isRequestList();

        return MyProgress();
      } else {
        return MyProgress(status: false);
      }
    }

    return CardItem(
      item: item,
      onClick: () {
        print(item);
      },
    );
  }

  // 分配资讯数据请求
  void isRequestList() {
    if (_currentIndex == 0) {
      // 请求矿井动态数据
      getList1Widget();
    } else if (_currentIndex == 1) {
      // 请求最新课程数据
      getList2Widget();
    }
  }

  // 请求矿井动态（新闻）数据
  void getList1Widget() async {
    try {
      var result = await myRequest(path: "/api/news/getNewsAll");
      List data = result["data"];
      List<Map> list = data.map((item) {
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
        _totalLength = result['total'];
        this.list.addAll(list);
      });
    } catch (e) {
      print(e);
    }
  }

  // 请求最新课程数据
  void getList2Widget() async {
    print('请求最新课程数据');

    try {
      var result = await myRequest(path: "/api/course/getCourseAll");
      List data = result["data"];
      List<Map> list = data.map((item) {
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
          "title": item['name'], //标题
          "status": item['status'], //状态，是否学完
          "view_num": item['view_num'], //学习人数
          "addtime": addtime, //添加时间
        };
      }).toList();

      setState(() {
        _totalLength = result['total'];
        this.list.addAll(list);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// 轮播图
class MyBanner extends StatefulWidget {
  MyBanner({Key key}) : super(key: key);

  @override
  _MyBannerState createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  List _bannerList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取轮播图
    getBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: AspectRatio(
        aspectRatio: 16 / 8, //设置子组件的宽高比例
        child: _bannerList == null
            ? null
            : Swiper(
                itemBuilder: (BuildContext context, int index) {
                  var item = _bannerList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['img_src'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                itemCount: _bannerList.length,
                pagination: new SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: Colors.black54,
                  activeColor: Colors.white,
                )),
                // control: new SwiperControl(),
                scrollDirection: Axis.horizontal,
                autoplay: true,
                onTap: (index) => print('点击了第$index个'),
              ),
      ),
    );
  }

  // 获取banner图
  getBanner() async {
    try {
      var result = await myRequest(path: '/api/index/getBanner');
      List data = result["data"];
      data = data.map((item) {
        if (item['type_link'] == 1 || item['type_link'] == 3) {
          return {
            "img_src": item['thumb_url'], //图片地址
            "type_link": item['type_link'], //链接类型
            "page_name": "", //跳转到哪个页面
          };
        } else if (item['type_link'] == 2) {
          return {
            "img_src": item['thumb_url'], //图片地址
            "type_link": item['type_link'], //链接类型
            "page_name": "", //跳转到哪个页面
          };
        } else if (item['type_link'] == 5) {
          if (item['news_type'] == 2) {
            // 视频
            return {
              "img_src": item['thumb_url'], //图片地址
              "type_link": item['type_link'], //链接类型
              "page_name": "", //跳转到哪个页面
            };
          } else {
            // 图文
            return {
              "img_src": item['thumb_url'], //图片地址
              "type_link": item['type_link'], //链接类型
              "page_name": "", //跳转到哪个页面
            };
          }
        } else {
          return {
            "img_src": item['thumb_url'], //图片地址
            "type_link": item['type_link'], //链接类型
            "page_name": "", //跳转到哪个页面
          };
        }
      }).toList();

      setState(() {
        _bannerList = data;
      });
    } catch (e) {
      print(e);
    }
  }
}

// 快捷导航
class FastNavList extends StatelessWidget {
  FastNavList({Key key}) : super(key: key);

  List<Map> _navList = [
    {"icon": "assets/images/01.png", "title": "一日一题", "router": "/dayTopic"},
    {
      "icon": "assets/images/02.png",
      "title": "课程学习",
    },
    {"icon": "assets/images/03.png", "title": "职工服务", "router": "/staffServe"},
    {
      "icon": "assets/images/04.png",
      "title": "通知公告",
      "router": "/informAffiche"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _navList.map((item) {
          // GestureDetector
          return GestureDetector(
            onTap: () {
              print("点击了快捷导航：$item");
              if (item['title'] == '课程学习') {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      //  FadeTransition 淡入淡出组件
                      return FadeTransition(
                        opacity: animation,
                        child: MyBottomNavigationBar(
                          currentIndex: 2,
                        ),
                      );
                    },
                  ),
                  (route) => route == null, //将所有路由清空
                );
              } else {
                Navigator.pushNamed(context, "${item['router']}");
              }
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Image.asset(
                    item['icon'],
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    item['title'],
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 最新考试
class NewestTest extends StatefulWidget {
  NewestTest({Key key}) : super(key: key);

  @override
  _NewestTestState createState() => _NewestTestState();
}

class _NewestTestState extends State<NewestTest> {
  List<Map> newsTest = [];

  _NewestTestState() {
    createWidget();
  }

  @override
  Widget build(BuildContext context) {
    if (newsTest.length == 0) {
      return Text("");
    }
    return Column(
      children: [
        // 头部标题
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "最新考试",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        //  FadeTransition 淡入淡出组件
                        return FadeTransition(
                          opacity: animation,
                          child: MyBottomNavigationBar(
                            currentIndex: 3,
                          ),
                        );
                      },
                    ),
                    (route) => route == null, //将所有路由清空
                  );
                },
                child: Text("查看更多 >"),
              ),
            ],
          ),
        ),

        // x轴滚动
        Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: newsTest.map((item) {
                double right = 10.0;

                if (item == newsTest[newsTest.length - 1]) {
                  right = 0.0;
                }

                return Container(
                  margin: EdgeInsets.only(right: right),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 280,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // tag标签
                          MyTags(
                            radius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            bgColor: item['type'] == 0
                                ? Colors.grey
                                : item['type'] == 1
                                    ? Colors.green
                                    : Colors.red,
                            title: item['type'] == 0
                                ? "未开始"
                                : item['type'] == 1
                                    ? '进行中'
                                    : "已结束",
                          ),

                          // 考试标题
                          Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            child: Text(
                              "${item['title']}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // 考试时间
                          Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            child: Text(
                                "${item['start_date']} 至 ${item['end_date']}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  // 获取最新考试数据，并创建Widget
  void createWidget() async {
    try {
      var result = await myRequest(path: "/api/test/newsTest");
      List newsList = result['data'];

      // 遍历获取的数据
      newsList.forEach((item) {
        int testType = item['type']; //考试类型
        DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
            item['start_date'] * 1000); //开始时间
        DateTime endDate =
            DateTime.fromMillisecondsSinceEpoch(item['end_date'] * 1000); //结束时间

        String startTime =
            formatDate(startDate, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
        String endTime =
            formatDate(endDate, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);

        if (testType != 2) {
          // 添加数据到数组中
          setState(() {
            newsTest.add({
              "type": item['type'], //考试类型
              "start_date": startTime, //开始时间
              "end_date": endTime, //结束时间
              "title": item["title"], //考试标题
            });
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
