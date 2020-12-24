// 课程详情
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pansan_app/components/MyVideoPlayer.dart';
import 'package:pansan_app/components/PanSanLogo.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pansan_app/pages/filePreview.dart';
import '../models/CourseDataType.dart';
import '../models/CourseChapterDataType.dart';
import '../models/MateriaDataType.dart';
import '../utils/myRequest.dart';
import '../mixins/withScreenUtil.dart';
import '../components/MyIcon.dart';
import '../components/MyAudioplayers.dart';

class CourseDetail extends StatefulWidget {
  final CourseDataType arguments;
  CourseDetail({Key key, @required this.arguments}) : super(key: key);

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> with MyScreenUtil {
  GlobalKey aspectRatioKey = GlobalKey();
  GlobalKey<MyVideoPlayerState> videoKey = GlobalKey(); //视频key
  GlobalKey<MyAudioplayersState> audioKey = GlobalKey(); //音频key
  CourseDataType arguments;
  List<CourseChapterDataType> chapterList = []; //章节
  int chapterId; //被点击的子章节的父章节id
  ChapterChildren chapterChildren; //被点击的章节下的子章节
  int chapterTotal = 0; //章节数量
  int articleListTotal = 0; //课时
  int view_num = 0; //在学人数
  int currentNavIndex = 1; //导航栏下标
  MateriaDataType audioMateria; //音频资源
  MateriaDataType videoMateria; //视频资源
  double paddingTop = 0.0;

  Duration playPosition; //播放的进度

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    arguments = widget.arguments;

    // 获取课程详情
    this.getCourseDetail();
  }

  @override
  void dispose() {
    // 音视频  阅读完成请求
    readAccomplish();

    super.dispose();
  }

  // 获取课程详情信息
  getCourseDetail() async {
    try {
      var result = await myRequest(
        path: "/api/course/courseDetail",
        data: {
          "id": arguments.id,
          "user_id": 1,
        },
      );
      List chapter = result['data']['chapter'];

      chapterTotal = result['data']['chapterTotal'];
      articleListTotal = result['data']['articleListTotal'];
      view_num = result['data']['view_num'];

      chapterList = chapter.map((e) {
        List children = e['children'].map((child) {
          var study_duration = child['materia']['study_duration'];
          var duration = child['materia']['duration'];
          return {
            "id": child['id'],
            "d_id": child['d_id'],
            "pid": child['pid'],
            "materia_id": child['materia_id'],
            "course_id": child['course_id'],
            "name": child['name'],
            "desc": child['desc'],
            "type": child['type'],
            "thumb_url": child['thumb_url'],
            "link": child['link'],
            "content": child['content'],
            "is_sj": child['is_sj'],
            "addtime": child['addtime'],
            "sorts": child['sorts'],
            "status": child['status'],
            "issue": child['issue'],
            "materia": {
              "id": child['materia']['id'],
              "name": child['materia']['name'],
              "type": child['materia']['type'],
              "link": child['materia']['link'],
              "key": child['materia']['key'],
              "fileId": child['materia']['fileId'],
              "duration": duration,
              "size": child['materia']['size'],
              "thumb_url": child['materia']['thumb_url'],
              "sorts": child['materia']['sorts'],
              "addtime": child['materia']['addtime'],
              "study_duration": study_duration,
            },
            "duration": child['duration'],
            "stuDoc": child['stuDoc'],
            "stuImgText": child['stuImgText'],
            "news_content": child['news_content'],
            "stuAudio": child['stuAudio'],
            "stuVideo": child['stuVideo'],
          };
        }).toList();

        return CourseChapterDataType.fromJson({
          "id": e['id'],
          "d_id": e['d_id'],
          "pid": e['pid'],
          "mid": e['mid'],
          "name": e['name'],
          "addtime": e['addtime'],
          "sorts": e['sorts'],
          "status": e['status'],
          "is_sj": e['is_sj'],
          "examine": e['examine'],
          "issue": e['issue'],
          "children": children,
        });
      }).toList();
    } catch (e) {
      print("报错信息$e  -------  课程id：${arguments.id}");
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  // 音视频  阅读完成请求
  readAccomplish() async {
    // 判断是否选择了章节
    if (chapterChildren != null) {
      // 判断选择的是不是图文和文件
      if (chapterChildren.type == 3) {
        //图文
        return;
      } else if (chapterChildren.type == 4) {
        //文件
        return;
      }

      // 音视频进度
      int duration = playPosition.inSeconds;
      int validTime = 0;

      if (chapterChildren.type == 1) {
        //音频有效阅读时间
        validTime = chapterChildren.stuAudio;
      } else if (chapterChildren.type == 2) {
        //视频有效阅读时间
        print("视频有效阅读时间 ${chapterChildren.stuVideo}");
        validTime = chapterChildren.stuVideo;
      }

      // 上传数据前先更新之前后台给的音视频进度
      print("上传数据前先更行之前后台给的音视频进度");
      chapterChildren.materia.studyDuration = duration;

      // 需要发给后台的数据
      var data = {
        "course_id": arguments.id, //课程id
        "chapter_id": chapterId, //章节id
        "article_id": chapterChildren.id, //子章节id
        "duration": duration, //播放进度
        "finish": duration >= validTime, //是否完成
        "user_id": true,
        "type": chapterChildren.materia.type, //资源类型
      };
      print("$data");

      try {
        var result = await myRequest(
          path: "/api/course/courseProgress",
          data: data,
        );
      } catch (e) {
        print(e);
      }
    }
  }

  // 获取播放进度
  getPlayPosition(position) {
    playPosition = position;
  }

  @override
  Widget build(BuildContext context) {
    if (aspectRatioKey.currentContext != null) {
      paddingTop = aspectRatioKey.currentContext
          .findRenderObject()
          .semanticBounds
          .size
          .height;
    }

    // 添加时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      arguments.addtime * 1000,
    );
    String _addtime = formatDate(
      addtime,
      [yyyy, '-', mm, '-', dd],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("课程详情"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 视频
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: 2 / 1,
              child: Container(
                key: aspectRatioKey,
                width: double.infinity,
                height: double.infinity,
                child: videoMateria == null
                    ? arguments.thumbUrl != ''
                        ? Image.network(
                            "${arguments.thumbUrl}", // 展示图
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          )
                        : PanSanLogo()
                    // 视频
                    : MyVideoPlayer(
                        key: videoKey,
                        aspectRatio: 2 / 1,
                        materia: videoMateria,
                        isSetProgress: false,
                        is_play: true,
                        // 刷新页面的回调
                        setStateCallball: () {
                          Future.delayed(Duration(milliseconds: 500))
                              .then((value) {
                            // 刷新页面
                            setState(() {});
                          });
                        },

                        // 获取播放进度的回调
                        getPlayPosition: getPlayPosition,
                      ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(
              top: paddingTop,
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                /// 标题
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    left: dp(20.0),
                    top: dp(20.0),
                    bottom: dp(20.0),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // 音频播放器
                      audioMateria != null
                          ? MyAudioplayers(
                              key: audioKey,
                              materia: audioMateria,

                              // 获取播放进度的回调
                              getPlayPosition: getPlayPosition,
                            )
                          : Text(""),

                      Container(
                        width: double.infinity,
                        child: Text(
                          "${arguments.name}",
                          style: TextStyle(fontSize: dp(32.0)),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 章节、课时、更新时间
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    left: dp(20.0),
                    bottom: dp(20.0),
                  ),
                  color: Colors.white,
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style:
                          TextStyle(color: Colors.black87, fontSize: dp(28.0)),
                      children: <InlineSpan>[
                        TextSpan(text: '$chapterTotal 章节 / '),
                        TextSpan(text: '$articleListTotal 课时 / '),
                        TextSpan(text: '$_addtime 更新'),
                      ],
                    ),
                  ),
                ),

                /// 在学人数
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    left: dp(20.0),
                    right: dp(20.0),
                    top: dp(20.0),
                    bottom: dp(20.0),
                  ),
                  margin: EdgeInsets.only(
                    top: dp(20.0),
                    bottom: dp(20.0),
                  ),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                              color: Colors.black87, fontSize: dp(28.0)),
                          children: <InlineSpan>[
                            TextSpan(text: '$view_num 人在学 | '),
                            TextSpan(text: '共 $chapterTotal 个章节'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("跳转到完成情况");
                        },
                        child: Row(
                          children: [
                            Text("完成情况 "),
                            Icon(
                              aliIconfont.arrows_right,
                              size: dp(26.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ///导航栏
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: dp(30.0),
                    bottom: dp(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentNavIndex = 0;
                          });
                        },
                        child: Text(
                          "课程介绍",
                          style: TextStyle(
                            color: currentNavIndex == 0
                                ? Colors.blue
                                : Colors.black87,
                            fontSize: dp(32.0),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentNavIndex = 1;
                          });
                        },
                        child: Text(
                          "课程目录",
                          style: TextStyle(
                            color: currentNavIndex == 1
                                ? Colors.blue
                                : Colors.black87,
                            fontSize: dp(32.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///导航栏对应的数据
                Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  child: currentNavIndex == 0
                      ? Html(
                          data: "${arguments.content}",
                          style: {
                            "p": Style(),
                          },
                        )
                      : Column(
                          children: chapterList.map((CourseChapterDataType e) {
                            List<ChapterChildren> children = e.children;
                            return Container(
                              width: double.infinity,
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Text('${e.name}'),

                                // 遍历子章节
                                children: children.map((child) {
                                  int index = children.indexOf(child) + 1;

                                  // 学习状态
                                  String status;
                                  Color statusColor;
                                  if (child.status == 1) {
                                    status = '已学完';
                                    statusColor = Colors.blue;
                                  } else if (child.status == 2) {
                                    status = '未学习';
                                    statusColor = Colors.grey;
                                  } else {
                                    status = '学习中';
                                    statusColor = Colors.green;
                                  }

                                  // 文件类型
                                  String type;
                                  if (child.type == 1) {
                                    type = '音频';
                                  } else if (child.type == 2) {
                                    type = '视频 ';
                                  } else if (child.type == 3) {
                                    type = '图文';
                                  } else if (child.type == 4) {
                                    type = '文件';
                                  }

                                  return Container(
                                    width: double.infinity,
                                    child: ListTile(
                                      leading: Text(
                                        "${index < 10 ? '0' + index.toString() : index}",
                                      ),
                                      title: Text("${child.name}"),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: dp(26.0),
                                            color: Colors.black87,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "$status",
                                              style: TextStyle(
                                                color: statusColor,
                                              ),
                                            ),
                                            TextSpan(text: "/$type"),
                                          ],
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 100.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                // 切换阅读时上传进度
                                                if (chapterChildren != child) {
                                                  // 上传阅读完成请求
                                                  readAccomplish();
                                                }

                                                print("子章节类型  ${child.type}");
                                                print(
                                                    "子章节类型  ${child.materia.type}");
                                                // 记录章节id
                                                chapterId = e.id;
                                                // 记录子章节
                                                chapterChildren = child;

                                                if (child.type == 1) {
                                                  // 音频

                                                  if (audioMateria == null ||
                                                      audioMateria.link !=
                                                          child.materia.link) {
                                                    setState(() {
                                                      //清空音频资源
                                                      audioMateria = null;
                                                      //清空视频资源
                                                      videoMateria = null;
                                                    });

                                                    Future.delayed(Duration(
                                                      milliseconds: 100,
                                                    )).then((value) {
                                                      setState(() {
                                                        //添加音频资源
                                                        audioMateria =
                                                            child.materia;
                                                      });
                                                    });
                                                  }
                                                } else if (child.type == 2) {
                                                  // 视频

                                                  setState(() {
                                                    //清空音频资源
                                                    audioMateria = null;

                                                    //添加视频资源
                                                    videoMateria =
                                                        child.materia;
                                                  });
                                                } else if (child.type == 3) {
                                                  // 图文

                                                  // 暂停视频播放
                                                  videoKey.currentState
                                                      ?.pause();
                                                  // 暂停音频播放
                                                  audioKey.currentState
                                                      ?.pause();

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return CourseTextDetail(
                                                          courseData: arguments,
                                                          arguments: child,
                                                          chapterId: e.id,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                } else if (child.type == 4) {
                                                  // 文件

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return FilePreview(
                                                          chapterId: e.id,
                                                          chapterChildren:
                                                              child,
                                                          courseData: arguments,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  top: dp(15.0),
                                                  bottom: dp(15.0),
                                                  left: dp(10.0),
                                                  right: dp(10.0),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: audioMateria ==
                                                              child.materia ||
                                                          videoMateria ==
                                                              child.materia
                                                      ? Colors.grey
                                                      : Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
                                                ),
                                                child: Text(
                                                  audioMateria ==
                                                              child.materia ||
                                                          videoMateria ==
                                                              child.materia
                                                      ? "学习中"
                                                      : "开始学习",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: dp(26.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                print('下载');
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  top: dp(15.0),
                                                  bottom: dp(15.0),
                                                  left: dp(10.0),
                                                  right: dp(10.0),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
                                                ),
                                                child: Text(
                                                  "下载",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: dp(26.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 课程图文详情
class CourseTextDetail extends StatefulWidget {
  CourseDataType courseData; //课程数据
  ChapterChildren arguments;
  int chapterId;
  CourseTextDetail({
    Key key,
    @required this.courseData,
    @required this.arguments,
    @required this.chapterId,
  }) : super(key: key);

  @override
  _CourseTextDetailState createState() => _CourseTextDetailState();
}

class _CourseTextDetailState extends State<CourseTextDetail> with MyScreenUtil {
  ChapterChildren arguments;
  int validTime; //阅读有效时间
  Timer _timer; //定时器

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    arguments = widget.arguments;

    // stuImgText: 1000  表示1000个字60秒为有效阅读时间
    validTime =
        (arguments.newsContent.length / arguments.stuImgText * 60).floor();

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
    // 发送阅读完成请求
    readAccomplish();

    _timer.cancel(); //清除定时器
    // TODO: implement dispose
    super.dispose();
  }

  // 阅读完成
  readAccomplish() async {
    try {
      var result = await myRequest(
        path: "/api/course/courseProgress",
        data: {
          "course_id": widget.courseData.id, //课程id
          "article_id": arguments.id, //图文id
          "type": arguments.type, //类型
          "duration": 0, //阅读时间
          "finish": validTime == 0, //是否完成
          "user_id": true,
          "chapter_id": widget.chapterId,
        },
      );
    } catch (e) {
      print(e);
    }
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
        title: Text("图文详情"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 有效时间倒计时
          Container(
            width: double.infinity,
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
          Expanded(
            child: ListView(
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
                    "${arguments.name}",
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
                // html
                Html(
                  data: "${arguments.content}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
