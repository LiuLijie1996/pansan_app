import 'package:flutter/material.dart';
import '../components/MyIcon.dart';
import '../mixins/mixins.dart';
import '../components/MyProgress.dart';
import '../models/UserInfoDataType.dart';
import '../components/MyProgress.dart';
import '../db/UserDB.dart';

// 我的页面
class My extends StatefulWidget {
  My({Key key}) : super(key: key);

  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> with UserInfoMixin {
  UserInfoDataType user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取用户信息
    this.userInfo();
  }

  @override
  // TODO: implement userInfo
  Future<UserInfoDataType> userInfo() async {
    user = await super.userInfo();

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: MyProgress(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("职工素质提升平台"),
        elevation: 0,
        backgroundColor: Color(0xff3487ff),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 头部
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              width: double.infinity,
              height: 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/header_bg.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // 头像
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              "${user.headUrl != null ? user.headUrl : 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2725210985,2088815523&fm=26&gp=0.jpg'}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user.name}",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${user.department}",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: InkWell(
                      onTap: () async {
                        await Navigator.pushNamed(context, "/myInformation");

                        List<UserInfoDataType> userDB = await UserDB.findAll();
                        user = userDB[0];

                        setState(() {});
                      },
                      child: Icon(
                        myIcon['bi'],
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // 快捷导航
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(bottom: 10.0),
              child: FastNavList(),
            ),

            // 功能列表
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: FunctionList(
                setState: () async {
                  List<UserInfoDataType> userDB = await UserDB.findAll();
                  user = userDB[0];

                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
      // drawer: Drawer(),
    );
  }
}

// 快捷导航
class FastNavList extends StatelessWidget with MyScreenUtil {
  const FastNavList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List croList = [
      {
        "icon": "assets/images/course.png",
        "title": "我的课程",
        "router": "/myCourse",
      },
      {
        "icon": "assets/images/mistake.png",
        "title": "我的错题",
        "router": "/myMistakes",
      },
      {
        "icon": "assets/images/collect.png",
        "title": "我的收藏",
        "router": "/myCollect",
      },
      {
        "icon": "assets/images/record.png",
        "title": "考试记录",
        "router": "/testRecords",
      },
    ];

    return Container(
      padding: EdgeInsets.only(top: dp(20.0), bottom: dp(20.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dp(20.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: dp(20.0), //阴影范围
            spreadRadius: 0.1, //阴影浓度
            color: Colors.grey[300], //阴影颜色
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: croList.map((e) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, e['router']);
            },
            child: Column(
              children: [
                Container(
                  width: dp(60.0),
                  child: Image.asset("${e['icon']}"),
                ),
                SizedBox(
                  height: dp(10.0),
                ),
                Text(
                  "${e['title']}",
                  style: TextStyle(fontSize: dp(24.0)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 功能列表
class FunctionList extends StatelessWidget with MyScreenUtil {
  Function() setState;
  FunctionList({Key key, this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List funcList = [
      {
        "icon": "assets/images/my_data.png",
        "title": "我的资料",
        "router": "/myInformation",
      },
      {
        "icon": "assets/images/my_class.png",
        "title": "我的班级",
        "router": "/myGrade",
      },
      {
        "icon": "assets/images/05.png",
        "title": "考试排行",
        "router": "/examRanking",
      },
      {
        "icon": "assets/images/jifen.png",
        "title": "积分中心",
        "router": "/integralCentre"
      },
      {
        "icon": "assets/images/FAQs.png",
        "title": "我的咨询",
        "router": "/myAdvisory",
      },
      {
        "icon": "assets/images/set.png",
        "title": "设置",
        "router": "/settings",
      },
    ];

    return ListView.separated(
      shrinkWrap: true, //让当前ListView构建的子组件尽量伸缩
      physics: NeverScrollableScrollPhysics(), //设置不滑动；既可以设置滑动效果还可以设置不滑动
      itemCount: funcList.length,
      itemBuilder: (BuildContext context, int index) {
        var e = funcList[index];
        return InkWell(
          onTap: () async {
            // 路由跳转
            await Navigator.pushNamed(context, "${e['router']}");

            if (e['router'] == '/myInformation') {
              setState();
            }
          },
          child: Container(
            width: dp(50.0),
            padding: EdgeInsets.only(
              left: dp(20.0),
              right: dp(20.0),
              top: dp(16.0),
              bottom: dp(16.0),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: dp(20.0),
                ),
                Image.asset(
                  "${e['icon']}",
                  width: dp(40.0),
                ),
                SizedBox(
                  width: dp(40.0),
                ),
                Text("${e['title']}"),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
