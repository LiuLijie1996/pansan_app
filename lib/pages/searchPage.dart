import 'package:flutter/material.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/CourseDataType.dart';
import '../utils/ErrorInfo.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with MyScreenUtil {
  TextEditingController _inputController = TextEditingController(); //搜索框的控制器
  FocusNode _inputFocus = FocusNode();
  String searchValue = ''; //需要搜索的内容

  ///联想词
  List<CourseDataType> associateList = [];

  ///关键词
  List<String> antistopList = [];

  @override
  void initState() {
    super.initState();

    // 获取关键词
    getAntistop();

    Future(() {
      // 获取焦点
      FocusScope.of(context).requestFocus(_inputFocus);
    });
  }

  @override
  void dispose() {
    // 释放输入框资源
    _inputController.dispose();
    super.dispose();
  }

  // 获取关键词
  getAntistop() async {
    try {
      var result = await myRequest(path: MyApi.getCourseTags);
      List data = result['data'];
      antistopList = data.map((e) {
        return "${e['name']}";
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (err) {
      ErrorInfo(
        errInfo: err,
        msg: "获取关键词失败",
      );
    }
  }

  // 获取联想词
  getAssociate() async {
    try {
      var result = await myRequest(
        path: MyApi.courseList,
        data: {
          "searchValue": searchValue,
          "page": 0,
          "psize": 0,
          "user_id": true,
        },
      );
      List data = result['data'];
      associateList = data.map((e) {
        return CourseDataType.fromJson({
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
        });
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (err) {
      ErrorInfo(
        errInfo: err,
        msg: "获取联想词失败",
      );
    }
  }

  // 搜索课程
  searchCourse() {
    // 搜索课程
    Navigator.pushNamed(context, "/courseList", arguments: {
      "searchValue": searchValue ?? '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: dp(80.0),
          child: TextField(
            controller: _inputController,
            focusNode: _inputFocus,
            onChanged: (value) {
              searchValue = value;
              // 获取联想词
              getAssociate();
            },
            decoration: InputDecoration(
              hintText: '请输入你要搜索的内容',
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.only(
                top: dp(20.0),
                left: dp(20.0),
                bottom: dp(20.0),
                right: dp(20.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00FF0000)),
                borderRadius: BorderRadius.all(
                  Radius.circular(dp(10.0)),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00000000)),
                borderRadius: BorderRadius.all(
                  Radius.circular(dp(10.0)),
                ),
              ),
            ),
          ),
        ),
        actions: [
          // 点击搜索
          InkWell(
            onTap: () {
              // 跳转页面
              Navigator.pushNamed(
                context,
                "/courseList",
                arguments: {"searchValue": searchValue},
              );

              _inputController.text = ''; //清空输入框内容
              _inputFocus.unfocus(); //失去焦点
              searchValue = ''; //删除要搜索的内容
              associateList = []; //清空联想词
            },
            child: Container(
              margin: EdgeInsets.only(right: dp(20.0)),
              child: Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 联想词组件
          associateList.length != 0
              ? AssociateWidget(
                  associateList: associateList,
                  onClick: (value) {
                    searchValue = value.name; //记录要搜索的内容

                    // 点击联想词直接进入课程详情
                    Navigator.pushNamed(
                      context,
                      '/courseDetail',
                      arguments: value,
                    );

                    _inputFocus.unfocus(); //失去焦点
                    _inputController.text = ''; //清空输入框内容
                    associateList = []; //清空联想词
                    searchValue = ''; //删除要搜索的内容
                  },
                )
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: dp(20.0), right: dp(20.0)),
                    child: ListView(
                      children: [
                        // 关键词
                        Antistop(
                          antistopList: antistopList,
                          onClick: (value) {
                            // 点击关键词，跳转到课程列表
                            Navigator.pushNamed(
                              context,
                              "/courseList",
                              arguments: {"searchValue": value, "isTags": true},
                            );
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
}

// 用来装联想词的组件
class AssociateWidget extends StatelessWidget with MyScreenUtil {
  ///联想词
  List<CourseDataType> associateList;

  ///点击联想词时触发的回调
  Function(CourseDataType) onClick;
  AssociateWidget({
    Key key,
    @required this.associateList,
    @required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: associateList.length,
        itemBuilder: (context, index) {
          CourseDataType e = associateList[index];
          return InkWell(
            onTap: () {
              onClick(e);
            },
            child: Container(
              padding: EdgeInsets.all(dp(20.0)),
              child: Text("${e.name}"),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}

// 关键词
class Antistop extends StatelessWidget with MyScreenUtil {
  ///关键词
  List<String> antistopList = [];

  ///点击关键词时触发的回调
  Function(String) onClick;
  Antistop({Key key, @required this.antistopList, @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: dp(20.0), bottom: dp(20.0)),
          child: Text(
            "关键词",
            style: TextStyle(
              fontSize: dp(32.0),
            ),
          ),
        ),

        // 关键词
        Container(
          width: double.infinity,
          child: Wrap(
            spacing: dp(20.0),
            runSpacing: dp(20.0),
            children: antistopList.map((e) {
              return InkWell(
                onTap: () {
                  onClick("$e");
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: dp(20.0),
                    right: dp(20.0),
                    top: dp(10.0),
                    bottom: dp(10.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.grey[350],
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text("$e"),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
