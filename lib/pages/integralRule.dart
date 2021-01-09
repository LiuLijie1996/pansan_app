// 积分规则

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../utils/myRequest.dart';
import '../models/IntegralRuleDataType.dart';
import '../mixins/mixins.dart';
import '../utils/ErrorInfo.dart';
import "../components/MyIcon.dart";
import '../components/MyProgress.dart';

class IntegralRule extends StatefulWidget {
  IntegralRule({Key key}) : super(key: key);

  @override
  _IntegralRuleState createState() => _IntegralRuleState();
}

class _IntegralRuleState extends State<IntegralRule> with MyScreenUtil {
  IntegralRuleDataType integralRuleDataList;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int fontSize = 120;
  List fontSizeList = [120, 80, 100, 140, 160, 180, 200];
  List titleList = ["默认字体", '超小字体', '小字体', '中等字体', '大字体', '大号字体', "超大号字体"];

  ///初始化是否完成
  bool isInitialize = false;

  @override
  void initState() {
    super.initState();

    // 获取积分规则
    getIntegralRuleData();
  }

  // 获取积分规则
  getIntegralRuleData() async {
    try {
      var result = await myRequest(path: MyApi.getScoreRule);
      Map data = result['data'];
      integralRuleDataList = IntegralRuleDataType.fromJson({
        "id": data['id'],
        "content": data['content'],
      });

      // 刷新页面
      if (this.mounted) {
        isInitialize = true;
        setState(() {});
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取积分规则失败",
        path: MyApi.getScoreRule,
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("积分规则"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
            icon: Icon(
              aliIconfont.wenzi,
              color: Colors.white,
            ),
          ),
        ],
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
      body: Html(
        data: "<div>${integralRuleDataList.content}</div>",
        style: {
          "div": Style(
            fontSize: FontSize.percent(fontSize),
            lineHeight: dp(3.0),
          ),
        },
      ),
      // body: CustomScrollView(
      //   slivers: [
      //     SliverToBoxAdapter(
      //       child: Container(
      //         padding: EdgeInsets.all(dp(20.0)),
      //         child: Text("潘三矿职工素质提升平台积分规则如下："),
      //       ),
      //     ),
      //     SliverList(
      //       delegate: SliverChildBuilderDelegate(
      //         (context, index) {
      //           IntegralRuleDataType item = integralRuleDataList[index];
      //           List<IntegralRuleChild> children = item.child;
      //           int upperLimit = item.upperLimit;
      //           String limitStr = '每日上限$upperLimit分';

      //           if (item.type == 2) {
      //             limitStr = '每场上限$upperLimit分';
      //           }

      //           return Container(
      //             padding: EdgeInsets.all(dp(20.0)),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 RichText(
      //                   text: TextSpan(
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.w700,
      //                       color: Colors.black,
      //                       fontSize: dp(32.0),
      //                     ),
      //                     children: [
      //                       TextSpan(
      //                         text: "${item.name} ",
      //                         children: [
      //                           TextSpan(
      //                             style: TextStyle(
      //                               fontWeight: FontWeight.w700,
      //                               fontSize: dp(30.0),
      //                               color: Colors.red,
      //                             ),
      //                             text: "( $limitStr )",
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 RichText(
      //                   text: TextSpan(
      //                     style: TextStyle(
      //                       fontSize: dp(30.0),
      //                       color: Colors.black,
      //                     ),
      //                     children: <InlineSpan>[
      //                       ...children.map((child) {
      //                         String content = '';

      //                         int childIndex = children.indexOf(child);
      //                         String n =
      //                             childIndex == children.length - 1 ? '' : "\n";

      //                         if (item.type == 1) {
      //                           content += "每日首次登录获取${child.score}分。";
      //                         } else if (item.type == 2) {
      //                           content +=
      //                               "考试分数在${child.mark1}-${child.mark2}分之间获取${child.score}分；$n";
      //                         } else if (item.type == 3) {
      //                           content += "每有效阅读一篇获取${child.score}分；";
      //                         } else if (item.type == 5) {
      //                           String name = '';
      //                           if (child.name == '视频') {
      //                             name = '观看';
      //                           } else if (child.name == '音频') {
      //                             name = '收听';
      //                           } else if (child.name == '图文') {
      //                             name = '阅读';
      //                           }
      //                           content +=
      //                               "${child.name}：每有效$name一篇获取${child.score}分；$n";
      //                         } else if (item.type == 6) {
      //                           content += "每有效阅读一题获取${child.score}分；";
      //                         }

      //                         return TextSpan(text: '$content');
      //                       }).toList(),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //         childCount: integralRuleDataList.length,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
