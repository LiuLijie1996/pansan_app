import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pansan_app/models/NewsDataType.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/utils/myRequest.dart';
import 'dart:async';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

// import 'package:flutter_tts/flutter_tts.dart';

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
  List titleList = ["默认字体", '超小字体', '小字体', '中等字体', '大字体', '超大字体', "超大大字体"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    arguments = widget.arguments;

    // 胡群殴新闻详情
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

  @override
  void dispose() {
    _timer?.cancel(); //清除定时器

    // 关闭语音播报
    // _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 添加时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      arguments.addtime * 1000,
    );
    String _addtime = formatDate(
      addtime,
      [yyyy, '年', mm, '月', dd, '日'],
    );

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
              // Container(
              //   margin: EdgeInsets.only(top: dp(60.0), bottom: dp(20.0)),
              //   child: AspectRatio(
              //     aspectRatio: 5 / 2,
              //     child: Image.asset(
              //       "assets/images/login_logo.png",
              //     ),
              //   ),
              // ),

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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor:
      //       arguments.newsContent == null ? Colors.grey : Colors.blue,
      //   child: Icon(isPlay ? Icons.pause : Icons.play_arrow),
      //   onPressed: () {
      //     if (arguments.newsContent == null) return;
      //     // 判断是否播放中
      //     if (isPlay) {
      //       // 判断是不是安卓,关闭播放
      //       if (Platform.isAndroid) {
      //         _stop();
      //       } else {
      //         _pause();
      //       }
      //     } else {
      //       speak(arguments.newsContent);
      //     }
      //     setState(() {
      //       isPlay = !isPlay;
      //     });
      //   },
      // ),
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
                            text: "${arguments.viewNum}次阅读 | ",
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
                  Html(
                    data: arguments.content,
                    style: {
                      "p": Style(
                        fontSize: FontSize.percent(fontSize),
                        lineHeight: dp(3.0),
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 获取新闻详情
  getNewsDetail() async {
    try {
      var result = await myRequest(
        path: "/api/news/getNewsOne",
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
            validTime =
                (arguments.newsContent.length / arguments.newsImgText * 60)
                    .floor();
          } else {
            validTime = arguments.newsVideo;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // 开启语言播报
  // Future speak(String text) async {
  //   /// 设置语言
  //   await flutterTts.setLanguage("zh-CN");

  //   /// 设置音量
  //   await flutterTts.setVolume(0.8);

  //   /// 设置语速
  //   await flutterTts.setSpeechRate(1);

  //   /// 音调
  //   await flutterTts.setPitch(1.0);

  //   var result = await flutterTts.speak(text);
  //   print("result $result");
  // }

  // /// 暂停（安卓不管用）
  // Future _pause() async {
  //   await flutterTts.pause();
  // }

  // /// 结束
  // Future _stop() async {
  //   await flutterTts.stop();
  // }

  // 阅读完成
  readAccomplish() async {
    try {
      var result = await myRequest(
        path: "/api/news/newsUserScore",
        data: {
          "id": arguments.id,
          "user_id": 1,
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
