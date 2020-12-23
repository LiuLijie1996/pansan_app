// 课程详情
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
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
  CourseDataType arguments;
  List<CourseChapterDataType> chapterList = []; //章节
  int chapterTotal = 0; //章节数量
  int articleListTotal = 0; //课时
  int view_num = 0; //在学人数
  int currentNavIndex = 1; //导航栏下标
  MateriaDataType currentClickMateria;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    arguments = widget.arguments;

    // 获取课程详情
    this.getCourseDetail();
  }

  @override
  Widget build(BuildContext context) {
    // 添加时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      arguments.addtime * 1000,
    );
    String _addtime = formatDate(
      addtime,
      [yyyy, '-', mm, '-', dd],
    );

    print(arguments.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("课程详情"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          /// 展示图
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Image.network(
              "${arguments.thumbUrl}",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

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
                currentClickMateria != null
                    ? MyAudioplayers(
                        materia: currentClickMateria,
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
                style: TextStyle(color: Colors.black87, fontSize: dp(28.0)),
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
                    style: TextStyle(color: Colors.black87, fontSize: dp(28.0)),
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
                      color:
                          currentNavIndex == 0 ? Colors.blue : Colors.black87,
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
                      color:
                          currentNavIndex == 1 ? Colors.blue : Colors.black87,
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
                                          if (child.type == 1) {
                                            print("刷新页面");

                                            if (currentClickMateria == null ||
                                                currentClickMateria.link !=
                                                    child.materia.link) {
                                              setState(() {
                                                currentClickMateria = null;
                                              });

                                              Future.delayed(Duration(
                                                milliseconds: 100,
                                              )).then((value) {
                                                setState(() {
                                                  currentClickMateria =
                                                      child.materia;
                                                });
                                              });
                                            }
                                          } else if (child.type == 2) {
                                            print('视频');
                                          } else if (child.type == 3) {
                                            print('图文');
                                          } else if (child.type == 4) {
                                            Navigator.pushNamed(
                                              context,
                                              '/filePreview',
                                              arguments: child,
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
                                            color: currentClickMateria ==
                                                    child.materia
                                                ? Colors.grey
                                                : Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                          ),
                                          child: Text(
                                            currentClickMateria == child.materia
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
                                                BorderRadius.circular(3.0),
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
    );
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
              "duration": child['materia']['duration'],
              "size": child['materia']['size'],
              "thumb_url": child['materia']['thumb_url'],
              "sorts": child['materia']['sorts'],
              "addtime": child['materia']['addtime']
            },
            "duration": child['duration'],
            "stuDoc": child['stuDoc'],
            "stuImgText": child['stuImgText'],
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

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {}
  }
}
