// 积分规则

import 'package:flutter/material.dart';
import '../utils/myRequest.dart';
import '../models/IntegralRuleDataType.dart';
import '../mixins/withScreenUtil.dart';

class IntegralRule extends StatefulWidget {
  IntegralRule({Key key}) : super(key: key);

  @override
  _IntegralRuleState createState() => _IntegralRuleState();
}

class _IntegralRuleState extends State<IntegralRule> with MyScreenUtil {
  List<IntegralRuleDataType> integralRuleDataList = [];

  @override
  void initState() {
    super.initState();

    // 获取积分规则
    getIntegralRuleData();
  }

  // 获取积分规则
  getIntegralRuleData() async {
    try {
      var result = await myRequest(context: context, path: MyApi.getScoreRule);
      List data = result['data'];
      integralRuleDataList = data.map((e) {
        var child = e['child'].map((item) {
          return {
            'id': item['id'],
            'pid': item['pid'],
            'name': item['name'],
            'num': item['num'],
            'score': item['score'],
            'frequency': item['frequency'],
            'mark1': item['mark1'],
            'mark2': item['mark2'],
            'addtime': item['addtime'],
            'type': item['type'],
            'status': item['status'],
            'sorts': item['sorts'],
            'upper_limit': item['upper_limit']
          };
        }).toList();
        return IntegralRuleDataType.fromJson({
          'id': e['id'],
          'name': e['name'],
          'type': e['type'],
          'upper_limit': e['upper_limit'],
          'addtime': e['addtime'],
          'update_time': e['update_time'],
          'status': e['status'],
          'sorts': e['sorts'],
          "child": child,
        });
      }).toList();

      // 刷新页面
      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("积分规则"),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(dp(20.0)),
              child: Text("潘三矿职工素质提升平台积分规则如下："),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                IntegralRuleDataType item = integralRuleDataList[index];
                List<IntegralRuleChild> children = item.child;
                int upperLimit = item.upperLimit;
                String limitStr = '每日上限$upperLimit分';

                if (item.type == 2) {
                  limitStr = '每场上限$upperLimit分';
                }

                return Container(
                  padding: EdgeInsets.all(dp(20.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: dp(32.0),
                          ),
                          children: [
                            TextSpan(
                              text: "${item.name} ",
                              children: [
                                TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: dp(30.0),
                                    color: Colors.red,
                                  ),
                                  text: "( $limitStr )",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: dp(30.0),
                            color: Colors.black,
                          ),
                          children: <InlineSpan>[
                            ...children.map((child) {
                              String content = '';

                              int childIndex = children.indexOf(child);
                              String n =
                                  childIndex == children.length - 1 ? '' : "\n";

                              if (item.type == 1) {
                                content += "每日首次登录获取${child.score}分。";
                              } else if (item.type == 2) {
                                content +=
                                    "考试分数在${child.mark1}-${child.mark2}分之间获取${child.score}分；$n";
                              } else if (item.type == 3) {
                                content += "每有效阅读一篇获取${child.score}分；";
                              } else if (item.type == 5) {
                                String name = '';
                                if (child.name == '视频') {
                                  name = '观看';
                                } else if (child.name == '音频') {
                                  name = '收听';
                                } else if (child.name == '图文') {
                                  name = '阅读';
                                }
                                content +=
                                    "${child.name}：每有效$name一篇获取${child.score}分；$n";
                              } else if (item.type == 6) {
                                content += "每有效阅读一题获取${child.score}分；";
                              }

                              return TextSpan(text: '$content');
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: integralRuleDataList.length,
            ),
          ),
        ],
      ),
    );
  }
}
