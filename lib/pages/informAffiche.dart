/*通知公告*/

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/MyIcon.dart';
import '../components/MyProgress.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../models/UserMessageDataType.dart';

class InformAffiche extends StatefulWidget {
  @override
  _InformAfficheState createState() => _InformAfficheState();
}

class _InformAfficheState extends State<InformAffiche> with MyScreenUtil {
  List<UserMessageDataType> dataList = [];

  @override
  void initState() {
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    // 请求数据
    this.getUserMessage();
  }

  // 请求数据
  getUserMessage() async {
    try {
      var result = await myRequest(
        path: MyApi.getUserMessage,
        data: {
          "user_id": true,
        },
      );
      List data = result['data'];
      dataList = data.map((e) {
        return UserMessageDataType.fromJson({
          "id": e['id'],
          "name": e['name'],
          "content": e['content'],
          "user_type": e['user_type'],
          "addtime": e['addtime'],
          "user": e['user'],
          "d_id": e['d_id'],
          "status": e['status'],
          "type": e['type'],
          "link_id": e['link_id'],
          "annex": e['annex'],
          "annex_name": e['annex_name'],
          "link": e['link'],
        });
      }).toList();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("通知公告"),
        centerTitle: true,
      ),
      body: dataList.length == 0
          ? MyProgress()
          : ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                UserMessageDataType item = dataList[index];

                // 格式化时间
                DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
                  item.addtime * 1000,
                );
                String _addtime = formatDate(
                  addtime,
                  [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn],
                );

                return InkWell(
                  onTap: () {
                    if (item.type == 1) {
                      // 跳转到通知公告的详情页
                      Navigator.pushNamed(
                        context,
                        "/afficheDetail",
                        arguments: item,
                      );
                    } else if (item.type == 2) {
                      // 跳转到咨询详情页
                      Navigator.pushNamed(
                        context,
                        "/advisoryDetail",
                        arguments: {
                          "id": item.id,
                          "pid": null,
                          "addtime": item.addtime,
                          "title": item.name,
                          "content": item.content,
                        },
                      );
                    }

                    //发送已读通知公告
                    myRequest(
                      path: MyApi.saveUserMessage,
                      data: {
                        "user_id": true,
                        "id": item.id,
                      },
                    );

                    setState(() {
                      item.status = 1;
                    });
                  },
                  child: ListTile(
                    leading: Icon(myIcon['bell']),
                    title: Text(
                      "${item.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "$_addtime",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: item.status == 1
                        ? Text("已读")
                        : Text(
                            "未读",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: dataList.length,
            ),
    );
  }
}
