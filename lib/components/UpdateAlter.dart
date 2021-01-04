import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///更新提示弹窗
class UpdateAlter {
  num dp(double width) {
    return ScreenUtil().setWidth(width);
  }

  // 弹窗提示更新
  showAlter(
    context, {

    ///更新的内容
    @required List updateContent,

    ///下载的地址
    @required String link,

    ///版本号
    @required version,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: dp(600.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(dp(20.0)),
              image: DecorationImage(
                image: AssetImage("assets/images/update_bg.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: dp(100.0),
                  alignment: Alignment.center,
                  child: Text(
                    "有新的版本请升级",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dp(36.0),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: dp(50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "版本号：v$version",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dp(32.0),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: dp(80.0), left: dp(20.0)),
                  width: double.infinity,
                  child: Text(
                    "更新内容",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: dp(32.0),
                    ),
                  ),
                ),

                // 更新内容
                Container(
                  padding: EdgeInsets.only(top: dp(20.0), left: dp(20.0)),
                  width: double.infinity,
                  height: dp(200.0),
                  child: ListView(
                    children: updateContent.map((e) {
                      return Container(
                        child: Text(
                          "${e['content']}",
                          style: TextStyle(
                            fontSize: dp(30.0),
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("暂不更新"),
                        ),
                        InkWell(
                          onTap: () async {
                            print("跳转更新 $link");
                            if (await canLaunch(link)) {
                              await launch(link);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          child: Text("立即更新"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
