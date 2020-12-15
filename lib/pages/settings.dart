// 设置页面
import 'package:flutter/material.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/pages/login.dart';

class Settings extends StatelessWidget with MyScreenUtil {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List settingList = [
      {"icon": myIcon['pwd'], "title": "修改密码", "router": "/updatePwd"},
      {"icon": myIcon['update'], "title": "检查更新", "router": ""},
      {"icon": myIcon['quit'], "title": "退出登录", "router": "/login"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: ListView.separated(
        shrinkWrap: true, //让当前ListView构建的子组件尽量伸缩
        physics: NeverScrollableScrollPhysics(), //设置不滑动；既可以设置滑动效果还可以设置不滑动
        itemCount: settingList.length,
        itemBuilder: (BuildContext context, int index) {
          var e = settingList[index];
          return InkWell(
            onTap: () {
              if (e['router'] != '') {
                if (e['router'] == '/login') {
                  // 路由替换
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Login();
                      },
                    ),
                    (route) => route == null,
                  );
                } else {
                  // 路由跳转
                  Navigator.pushNamed(context, "${e['router']}");
                }
              }
            },
            child: Container(
              width: dp(50.0),
              padding: EdgeInsets.only(
                left: dp(20.0),
                right: dp(20.0),
                top: index == 0 ? dp(24.0) : dp(16.0),
                bottom: dp(16.0),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: dp(20.0),
                  ),
                  Icon(e['icon']),
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
      ),
    );
  }
}
