// 公告详情

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../models/UserMessageDataType.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/fileMethod.dart';
import '../utils/myRequest.dart';

class AfficheDetail extends StatefulWidget {
  final UserMessageDataType arguments;
  AfficheDetail({Key key, @required this.arguments}) : super(key: key);

  @override
  _AfficheDetailState createState() => _AfficheDetailState();
}

class _AfficheDetailState extends State<AfficheDetail> with MyScreenUtil {
  int fontSize = 120;
  List fontSizeList = [120, 80, 100, 140, 160, 180, 200];
  List titleList = ["默认字体", '超小字体', '小字体', '中等字体', '大字体', '大号字体', "超大号字体"];

  @override
  void initState() {
    super.initState();

    // 初始化
    myInitialeze();
  }

  // 初始化
  myInitialeze() {}

  @override
  Widget build(BuildContext context) {
    print(widget.arguments.id);

    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      widget.arguments.addtime * 1000,
    );
    String _addtime = formatDate(
      addtime,
      [yyyy, '年', mm, '月', dd, "日"],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("公告详情"),
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
      body: ListView(
        children: [
          // 标题
          Container(
            padding: EdgeInsets.all(dp(20.0)),
            child: Text(
              "${widget.arguments.name}",
              style: TextStyle(
                fontSize: dp(46.0),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // 时间
          Container(
            padding: EdgeInsets.only(left: dp(20.0)),
            child: Text("$_addtime"),
          ),

          // 详情内容
          Html(
            data: "<div>${widget.arguments.content}</div>",
            style: {
              "div": Style(
                fontSize: FontSize.percent(fontSize),
                lineHeight: dp(3.0),
              ),
            },
          ),

          // 附件
          widget.arguments.annexName == null
              ? Container()
              : Container(
                  padding: EdgeInsets.only(
                    left: dp(20.0),
                    right: dp(20.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      // 打开文件
                      FilePreview(
                        context: context,
                        link: widget.arguments.link,
                        title: widget.arguments.name,
                      );
                    },
                    child: Text(
                      "附件：${widget.arguments.annexName}",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
