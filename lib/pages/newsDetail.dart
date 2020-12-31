import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../components/MyProgress.dart';
import "../components/MyVideoPlayer.dart";
import "../components/MyIcon.dart";
import '../models/NewsDataType.dart';
import '../models/MateriaDataType.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';

// 新闻详情页

class NewsDetail extends StatefulWidget {
  final NewsDataType arguments;
  NewsDetail({Key key, @required this.arguments}) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> with MyScreenUtil {
  NewsDataType arguments;
  int validTime;
  Timer _timer; //定时器
  // FlutterTts flutterTts = FlutterTts();
  bool isPlay = false;
  int fontSize = 120;
  List fontSizeList = [120, 80, 100, 140, 160, 180, 200];
  List titleList = ["默认字体", '超小字体', '小字体', '中等字体', '大字体', '大号字体', "超大号字体"];
  MateriaDataType materia;
  bool isInitialize = false; //初始化是否完成

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    arguments = widget.arguments;

    // 初始化
    myInitialize();
  }

  @override
  void dispose() {
    _timer?.cancel(); //清除定时器

    super.dispose();
  }

  // 初始化
  myInitialize() {
    // 获取新闻详情
    getNewsDetail();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (validTime != null) {
        if (this.mounted) {
          setState(() {
            --validTime;
          });

          if (validTime == 0) {
            _timer.cancel(); //清除定时器

            // 通知后台阅读完成
            readAccomplish();
          }
        }
      }
    });
  }

  // 获取新闻详情
  getNewsDetail() async {
    try {
      var result = await myRequest(
        path: MyApi.getNewsOne,
        data: {
          "id": arguments.id,
        },
      );
      var data = result['data'];
      var newData = {
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
      };

      if (this.mounted) {
        setState(() {
          arguments = NewsDataType.fromJson(newData);

          // 判断是图文还是视频
          if (arguments.type == 1) {
            // 图文播放时间
            validTime =
                (arguments.newsContent.length / arguments.newsImgText * 60)
                    .floor();
          } else {
            // 视频播放时间
            validTime = arguments.newsVideo;
            var jsonMateria = {
              "id": data['materia']['id'],
              "name": data['materia']['name'],
              "type": data['materia']['type'],
              "link": data['materia']['link'],
              "key": data['materia']['key'],
              "fileId": data['materia']['fileId'],
              "duration": data['materia']['duration'],
              "size": data['materia']['size'],
              "thumb_url": data['materia']['thumb_url'],
              "sorts": data['materia']['sorts'],
              "addtime": data['materia']['addtime']
            };
            materia = MateriaDataType.fromJson(jsonMateria);
            print(materia.link);
          }

          isInitialize = true;
        });
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取新闻详情失败",
        path: MyApi.getNewsOne,
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

    // 添加时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      arguments.addtime * 1000,
    );
    String _addtime = formatDate(
      addtime,
      [yyyy, '年', mm, '月', dd, '日'],
    );

    if (arguments.type == 1) {
      // 图文详情
      return Scaffold(
        appBar: AppBar(
          title: Text("新闻详情"),
          centerTitle: true,
        ),
        endDrawer: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: [
                SizedBox(height: dp(50.0)),
                ...fontSizeList.map((item) {
                  int index = fontSizeList.indexOf(item);
                  String title = titleList[index];

                  return ListTile(
                    leading: Radio(
                      value: item,
                      groupValue: fontSize,
                      onChanged: (value) {
                        setState(() {
                          fontSize = item;
                        });
                      },
                    ),
                    title: Text(
                      "$title",
                      style: TextStyle(
                        fontSize: dp(32.0),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        fontSize = item;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(dp(10.0)),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
                child: Text(
                  validTime == 0
                      ? '阅读完成'
                      : "有效阅读时间：${validTime != null ? validTime < 10 ? '0' + validTime.toString() : validTime : ''} 秒",
                  style: TextStyle(fontSize: dp(30.0)),
                ),
              ),
            ),

            // 文章内容
            Container(
              padding: EdgeInsets.only(top: dp(60.0)),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 标题
                    Container(
                      padding: EdgeInsets.only(
                        top: dp(20.0),
                        bottom: dp(20.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      child: Text(
                        "${arguments.title}",
                        style: TextStyle(
                          fontSize: dp(50.0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // 发布日期
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: dp(20.0),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: dp(30.0),
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              // text: "${arguments.viewNum}次阅读 | ",
                              children: [
                                TextSpan(
                                  text: "$_addtime发布",
                                  children: [],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Html
                    Html(
                      data: "<div>${arguments.content}</div>",
                      style: {
                        "div": Style(
                          fontSize: FontSize.percent(fontSize),
                          lineHeight: dp(3.0),
                        ),
                      },
                    ),

                    // 点赞数量
                    Container(
                      padding: EdgeInsets.only(
                        bottom: dp(20.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text("${arguments.viewNum}阅读"),
                              ],
                            ),
                          ),

                          // 点赞数量
                          Container(
                            child: InkWell(
                              child: Row(
                                children: [
                                  Icon(
                                    aliIconfont.zan,
                                    size: dp(32.0),
                                  ),
                                  SizedBox(width: dp(10.0)),
                                  Text("点赞"),
                                ],
                              ),
                              onTap: () async {
                                var result = await saveUserUpvote();
                                if (result == true) {
                                  Fluttertoast.showToast(
                                    msg: "点赞成功",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black45,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "点赞失败",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black45,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // 视频详情
      return Scaffold(
        appBar: AppBar(
          title: Text("新闻详情"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(dp(10.0)),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
                child: Text(
                  validTime == 0
                      ? '阅读完成'
                      : "有效阅读时间：${validTime != null ? validTime < 10 ? '0' + validTime.toString() : validTime : ''} 秒",
                  style: TextStyle(fontSize: dp(30.0)),
                ),
              ),
            ),

            // 文章内容
            Container(
              padding: EdgeInsets.only(top: dp(60.0)),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 标题
                    Container(
                      padding: EdgeInsets.only(
                        top: dp(20.0),
                        bottom: dp(20.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      child: Text(
                        "${arguments.title}",
                        style: TextStyle(
                          fontSize: dp(50.0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // 发布日期
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: dp(20.0),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: dp(30.0),
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              // text: "${arguments.viewNum}次阅读 | ",
                              children: [
                                TextSpan(
                                  text: "$_addtime发布",
                                  children: [],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 视频
                    Container(
                      margin: EdgeInsets.only(top: dp(20.0)),
                      child: MyVideoPlayer(materia: materia),
                    ),

                    // 点赞数量
                    Container(
                      padding: EdgeInsets.only(
                        top: dp(20.0),
                        bottom: dp(20.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text("${arguments.viewNum}阅读"),
                              ],
                            ),
                          ),

                          // 点赞数量
                          Container(
                            child: InkWell(
                              child: Row(
                                children: [
                                  Icon(
                                    aliIconfont.zan,
                                    size: dp(32.0),
                                  ),
                                  SizedBox(width: dp(10.0)),
                                  Text("点赞"),
                                ],
                              ),
                              onTap: () async {
                                var result = await saveUserUpvote();
                                if (result == true) {
                                  Fluttertoast.showToast(
                                    msg: "点赞成功",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black45,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "点赞失败",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black45,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // 阅读完成
  readAccomplish() async {
    try {
      await myRequest(
        path: MyApi.newsUserScore,
        data: {
          "id": arguments.id,
          "user_id": 1,
        },
      );
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "上传进度失败",
        path: MyApi.newsUserScore,
      );
    }
  }

  // 点赞
  Future<bool> saveUserUpvote() async {
    try {
      await myRequest(
        path: MyApi.saveUserUpvote,
        data: {
          "id": arguments.id,
        },
      );
      return true;
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "点赞失败",
        path: MyApi.saveUserUpvote,
      );
      return false;
    }
  }
}
