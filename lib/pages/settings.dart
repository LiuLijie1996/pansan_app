// 设置页面
import 'package:flutter/material.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/pages/login.dart';

class Settings extends StatelessWidget {
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
              width: 25.0,
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: index == 0 ? 12.0 : 8.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(e['icon']),
                  SizedBox(
                    width: 20.0,
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
