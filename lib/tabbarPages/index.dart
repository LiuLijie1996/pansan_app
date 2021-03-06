import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 扫码
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

// 组件
import '../components/CardItem.dart';
import '../components/MyProgress.dart';
import '../mixins/mixins.dart';
import '../tabbarPages/MyBottomNavigationBar.dart';
import '../components/MyIcon.dart';
import '../components/MyTags.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';

// 数据类型
import '../models/BannerDataType.dart';
import '../models/ExamListDataType.dart';
import '../models/NewsDataType.dart';
import '../models/CourseDataType.dart';
import '../models/SearchCourseDataType.dart';
import '../models/NavDataType.dart';

// 首页页面
class Index extends StatelessWidget with MyScreenUtil {
  const Index({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("职工素质提升平台"),
        actions: [
          UnconstrainedBox(
            child: Container(
              // width: 35.0,
              // height: 35.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                borderRadius: BorderRadius.circular(dp(80.0)),
              ),
              child: IconButton(
                onPressed: () {
                  scan(context);
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
              margin: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                borderRadius: BorderRadius.circular(dp(80.0)),
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

  Future scan(context) async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      String barcode = await BarcodeScanner.scan();
      var result1 = await myRequest(
        path: MyApi.userAddClass,
        data: {
          "user_id": true,
          "class_id": barcode,
        },
      );

      // 弹窗提示
      var alertResult = await showAlert(context, msg: '${result1['msg']}');

      // 判断是否确定
      if (alertResult) {
        Map myApi;

        // 判断签到还是加入班级
        if (result1['code'] == 101) {
          myApi = MyApi.addClass;
        } else {
          myApi = MyApi.signClass;
        }

        // 发送签到(或加入班级)请求
        var result2 = await myRequest(
          path: myApi,
          data: {
            "user_id": true,
            "class_id": barcode,
          },
        );

        Fluttertoast.showToast(
          msg: "${result2['msg']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        print(result2);
      }
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

      ErrorInfo(
        errInfo: e,
        // msg: "扫码错误",
        path: "",
      );
    }
  }

  Future<bool> showAlert(
    context, {
    msg = '',
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('$msg'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with MyScreenUtil {
  List<BannerDataType> bannerList = []; //轮播图
  List<ExamListDataType> examList = []; //最新考试
  List<NewsDataType> newsList = []; //新闻列表
  int newsPage = 1; //新闻分页
  int newsTotal = null; //新闻总个数

  List<CourseDataType> courseList = []; //课程列表
  int coursePage = 1; //课程分页
  int courseTotal = null; //课程总个数

  // 当前显示的是新闻列表还是课程列表
  int _currentIndex = 0;

  // 未读的通知公告
  int unreadNum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        // 清空数据
        deleteData();
        return futureGetData();
      },
      child: CustomScrollView(
        slivers: [
          // 轮播图
          SliverToBoxAdapter(
            child: MyBanner(dataList: bannerList),
          ),

          // 快捷导航
          SliverToBoxAdapter(
            child: FastNavList(unreadNum: unreadNum),
          ),

          // 最新考试
          SliverToBoxAdapter(
            child: NewsExam(dataList: examList),
          ),

          // 控制显示新闻还是课程
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: dp(20.0),
                right: dp(20.0),
                bottom: dp(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Text(
                            "推荐新闻",
                            style: TextStyle(
                              color: _currentIndex == 0
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: dp(32.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: dp(20.0)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Text(
                            "最新课程",
                            style: TextStyle(
                              color: _currentIndex == 1
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: dp(34.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 查看更多
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
                                currentIndex: _currentIndex == 0 ? 1 : 2,
                              ),
                            );
                          },
                        ),
                        (route) => route == null, //将所有路由清空
                      );
                    },
                    child: Text("查看更多>"),
                  ),
                ],
              ),
            ),
          ),

          _currentIndex == 0
              // 新闻列表
              ? SliverList(
                  // 构建代理
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == newsTotal) {
                        return MyProgress(status: false);
                      } else if (newsTotal == null ||
                          index == newsList.length) {
                        return Text("");
                      }

                      NewsDataType item = newsList[index];
                      if (index + 1 == newsList.length) {
                        // 判断后台还有没有数据了
                        if (newsList.length < newsTotal) {
                          // 到底了，请求数据
                          getNewsList(page: ++newsPage);
                          return MyProgress();
                        }
                      }

                      return NewsCardItem(
                        item: item,
                        onClick: () {
                          print("${item.toJson()}");
                        },
                      );
                    },
                    // 指定子元素的个数
                    childCount: newsList.length + 1,
                  ),
                )
              :
              // 课程列表
              SliverList(
                  // 构建代理
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == courseTotal) {
                        return MyProgress(status: false);
                      } else if (courseTotal == null ||
                          index == courseList.length) {
                        return Text("");
                      }

                      CourseDataType item = courseList[index];
                      if (index + 1 == courseList.length) {
                        // 判断后台还有没有数据了
                        if (courseList.length < courseTotal) {
                          getCourseList(page: ++coursePage);
                          return MyProgress();
                        }
                      }

                      return CourseCardItem(
                        item: item,
                        onClick: () {
                          print("${item.toJson()}");
                        },
                      );
                    },
                    // 指定子元素的个数
                    childCount: courseList.length + 1,
                  ),
                ),
        ],
      ),
    );
  }

  // 初始化
  myInitialize() {
    // // 获取轮播图
    // getBannerList();
    // // 获取最新考试
    // getExamList();
    // // 获取新闻
    // getNewsList();
    // // 获取课程
    // getCourseList();
    // // 获取未读的通知公告数量
    // getUnreadNum();

    futureGetData();
  }

  // 同步请求数据
  futureGetData() async {
    // 获取轮播图
    await getBannerList();
    // 获取最新考试
    await getExamList();
    // 获取新闻
    await getNewsList();
    // 获取课程
    await getCourseList();
    // 获取未读的通知公告数量
    await getUnreadNum();
  }

  // 清空数据
  deleteData() {
    bannerList = []; //轮播图
    examList = []; //最新考试
    newsList = []; //新闻列表
    newsPage = 1; //新闻分页
    newsTotal = null; //新闻总个数
    courseList = []; //课程列表
    coursePage = 1; //课程分页
    courseTotal = null; //课程总个数
    _currentIndex = 0; // 当前显示的是新闻列表还是课程列表
    unreadNum = 0; //未读的通知公告数量
  }

  // 获取轮播图
  getBannerList() async {
    try {
      var result = await myRequest(path: MyApi.indexBanner);

      List data = result['data'];

      bannerList = data.map((e) {
        return BannerDataType.fromJson({
          "id": e['id'],
          "name": e['name'],
          "position": e['position'],
          "type_link": e['type_link'],
          "link": e['link'],
          "thumb_url": e['thumb_url'],
          "addtime": e['addtime'],
          "status": e['status'],
          "sorts": e['sorts'],
          "link_name": e['link_name'],
          "news_type": e['news_type'],
        });
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取轮播图失败",
        path: MyApi.indexBanner,
      );
    }
  }

  // 获取未读的通知公告数量
  getUnreadNum() async {
    try {
      unreadNum = 0;
      var result = await myRequest(
        path: MyApi.getUserMessage,
        data: {
          "user_id": true,
        },
      );

      List data = result['data'];
      data.forEach((e) {
        var status = e['status'];
        if (status == 2) {
          unreadNum++;
        }
      });

      setState(() {});
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取通知公告失败",
        path: MyApi.getUserMessage,
      );
    }
  }

  // 获取最新考试
  getExamList() async {
    try {
      var result = await myRequest(
        path: MyApi.newKaoshi,
        data: {
          "user_id": true,
        },
      );

      List data = result['data'];

      data.forEach((e) {
        if (e['is_test'] == true) {
          ExamListDataType item = ExamListDataType.fromJson({
            "id": e['id'],
            "pid": e['pid'],
            "m_test_id": e['m_test_id'],
            "class_id": e['class_id'],
            "paper_id": e['paper_id'],
            "name": e['name'],
            "type": e['type'],
            "address": e['address'],
            "test_num": e['test_num'],
            "duration": e['duration'],
            "min_duration": e['min_duration'],
            "passing_mark": e['passing_mark'],
            "cut_screen_type": e['cut_screen_type'],
            "cut_screen_num": e['cut_screen_num'],
            "cut_screen_time": e['cut_screen_time'],
            "status": e['status'],
            "is_test": e['is_test'],
            "start_time": e['start_time'],
            "end_time": e['end_time']
          });

          examList.add(item);
        }
      });

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取最新考试失败",
        path: MyApi.newKaoshi,
      );
    }
  }

  // 获取新闻
  getNewsList({
    page = 1,
  }) async {
    try {
      var result = await myRequest(
        path: MyApi.getIndexNewsList,
        data: {
          "page": page,
          "psize": 20,
        },
      );

      List data = result['data'];
      newsTotal = result['total'];

      if (page == 1) {
        newsList = [];
      }
      newsList.addAll(data.map((e) {
        List<String> img_list = [];
        if (e['img_list'].length != 0) {
          e['img_list'].forEach((value) {
            img_list.add("$value");
          });
          e['img_list'] = img_list;
        } else {
          e['img_list'] = null;
        }

        return NewsDataType.fromJson(e);
      }).toList());

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取新闻失败",
        path: MyApi.getIndexNewsList,
      );
    }
  }

  // 获取课程
  getCourseList({
    page = 1,
  }) async {
    try {
      var result = await myRequest(
        path: MyApi.courseList,
        data: {
          "user_id": true,
          "page": page,
          "psize": 20,
        },
      );

      List data = result['data'];
      courseTotal = result['total'];

      print("-------获取课程${data.length}------");
      List<CourseDataType> newData = data.map((e) {
        List chapter = e['chapter'].map((item) {
          return {
            "id": item['id'],
            "pid": item['pid'],
            "d_id": item['d_id'],
            "name": item['name'],
            "addtime": item['addtime']
          };
        }).toList();
        return CourseDataType.fromJson({
          "id": e['id'],
          "d_id": e['d_id'],
          "pid": e['pid'],
          "name": e['name'],
          "desc": e['desc'],
          "content": e['content'],
          "status": e['status'],
          "addtime": e['addtime'],
          "thum_url": e['thum_url'],
          "user": e['user'],
          "user_type": e['user_type'],
          "sorts": e['sorts'],
          "is_sj": e['is_sj'],
          "examine": e['examine'],
          "issue": e['issue'],
          "study_status": e['study_status'],
          "thumb_url": e['thumb_url'],
          "chapter": chapter,
          "view_num": e['view_num'],
        });
      }).toList();

      if (this.mounted) {
        setState(() {
          if (page == 1) {
            courseList = [];
          }
          courseList.addAll(newData);
        });
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取课程失败",
        path: MyApi.courseList,
      );
    }
  }
}

/// 轮播图
class MyBanner extends StatelessWidget with MyScreenUtil {
  final List<BannerDataType> dataList;
  const MyBanner({Key key, @required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataList.length == 0) {
      return AspectRatio(aspectRatio: 16 / 8);
    }

    return AspectRatio(
      aspectRatio: 16 / 8,
      child: Swiper(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          BannerDataType item = dataList[index];
          return Padding(
            padding: EdgeInsets.all(dp(20.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(dp(20.0)),
              child: Image.network(
                item.thumbUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: Colors.black54,
            activeColor: Colors.white,
          ),
        ),
        // control: new SwiperControl(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (int index) async {
          BannerDataType item = dataList[index];
          print("${item.toJson()}");

          switch (item.typeLink) {
            // 0不跳转
            case 0:
              break;

            // 1考试分类
            case 1:
              Navigator.pushNamed(
                context,
                "/examSelect",
                arguments: NavDataType.fromJson(
                  {
                    "id": item.link,
                    "name": "${item.name}",
                  },
                ),
              );
              break;

            // 2课程列表
            case 2:
              Navigator.pushNamed(
                context,
                "/searchCourseList",
                arguments: SearchCourseDataType(
                  pid: item.link,
                ),
              );
              break;

            // 3练习分类
            case 3:
              Navigator.pushNamed(context, "/exerciseSelect");
              break;

            // 4考试列表
            case 4:
              Navigator.pushNamed(context, "/examSelect");
              break;

            // 5跳转到新闻详情
            case 5:
              this.pushNewsDetail(item, context);
              break;
          }
        },
      ),
    );
  }

  // 跳转到新闻详情
  pushNewsDetail(BannerDataType item, BuildContext context) async {
    try {
      var result = await myRequest(
        path: MyApi.getNewsOne,
        data: {
          "id": item.link,
        },
      );
      var data = result['data'];

      Navigator.pushNamed(
        context,
        "/newsDetail",
        arguments: NewsDataType.fromJson({
          "id": data['id'],
          "pid": data['pid'],
          "title": data['title'],
          "desc": data['desc'],
          "thumb_url": data['thumb_url'],
          "type": data['type'],
          "materia_id": data['materia_id'],
          "content": data['content'],
          "tuij": data['tuij'],
          "addtime": data['addtime'],
          "view_num": data['view_num'],
          "upvote": data['upvote'],
          "materia": data['materia'],
          "newsImgText": data['newsImgText'],
          "newsVideo": data['newsVideo'],
          "collect": data['collect'],
          "news_content": data['news_content'],
        }),
      );
    } catch (e) {
      ErrorInfo(
        msg: "获取新闻详情失败",
        errInfo: "$e",
        path: MyApi.getNewsOne,
      );
    }
  }
}

/// 快捷导航
class FastNavList extends StatelessWidget with MyScreenUtil {
  ///未读的通知公告数量
  final int unreadNum;
  const FastNavList({Key key, @required this.unreadNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map> _navList = [
      {"icon": "assets/images/01.png", "title": "一日一题", "router": "/dayTopic"},
      {
        "icon": "assets/images/02.png",
        "title": "课程学习",
      },
      {
        "icon": "assets/images/03.png",
        "title": "职工服务",
        "router": "/staffServe"
      },
      {
        "icon": "assets/images/04.png",
        "title": "通知公告",
        "router": "/informAffiche"
      },
    ];

    return Padding(
      padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(dp(20.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _navList.map((item) {
            // GestureDetector
            return GestureDetector(
              onTap: () async {
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
                padding: EdgeInsets.all(dp(30.0)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(dp(10.0))),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          item['icon'],
                          width: dp(100.0),
                          height: dp(100.0),
                        ),

                        // 角标
                        item['title'] != '通知公告'
                            ? Container()
                            : unreadNum == 0
                                ? Container()
                                : Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: dp(38.0),
                                      height: dp(38.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        "$unreadNum",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: dp(26.0),
                                        ),
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      item['title'],
                      style: TextStyle(fontSize: dp(24.0)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// 最新考试
class NewsExam extends StatelessWidget with MyScreenUtil {
  final List<ExamListDataType> dataList;
  const NewsExam({Key key, @required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataList.length == 0) {
      return Text('');
    }
    List<ExamListDataType> list = dataList;

    return Padding(
      padding: EdgeInsets.all(dp(20.0)),
      child: Column(
        children: [
          // 头部标题
          Container(
            padding: EdgeInsets.only(top: dp(20.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "最新考试",
                  style: TextStyle(
                    fontSize: dp(32.0),
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
            margin: EdgeInsets.only(top: dp(20.0)),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: list.map((item) {
                  double right = dp(20.0);

                  if (item == list[list.length - 1]) {
                    right = 0.0;
                  }

                  // 考试时间
                  DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
                    item.startTime * 1000,
                  );
                  String _startTime = formatDate(
                    startTime,
                    [yyyy, '-', mm, '-', dd, " ", HH, ":", mm],
                  );

                  // 考试结束时间
                  DateTime endTime = DateTime.fromMillisecondsSinceEpoch(
                    item.endTime * 1000,
                  );
                  String _endTime = formatDate(
                    endTime,
                    [yyyy, '-', mm, '-', dd, " ", HH, ":", mm],
                  );

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/examSiteInfo",
                        arguments: item,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: right),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(dp(20.0)),
                        child: Container(
                          width: dp(500.0),
                          height: dp(240.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // tag标签
                              MyTags(
                                radius: BorderRadius.only(
                                  bottomRight: Radius.circular(dp(20.0)),
                                ),
                                bgColor: Colors.green,
                                title: '进行中',
                              ),

                              // 考试标题
                              Container(
                                margin: EdgeInsets.only(
                                  top: dp(30.0),
                                  left: dp(20.0),
                                ),
                                child: Text(
                                  "${item.name}",
                                  style: TextStyle(
                                    fontSize: dp(32.0),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // 考试时间
                              Container(
                                margin: EdgeInsets.only(
                                  top: dp(30.0),
                                  left: dp(20.0),
                                ),
                                child: Text(
                                  "$_startTime 至 $_endTime",
                                  style: TextStyle(
                                    fontSize: dp(26.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
