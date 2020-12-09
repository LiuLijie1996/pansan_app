/*通知公告*/

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/utils/myRequest.dart';

class InformAffiche extends StatefulWidget {
  @override
  _InformAfficheState createState() => _InformAfficheState();
}

class _InformAfficheState extends State<InformAffiche> {
  List dataList = [];

  _InformAfficheState() {
    /*请求数据*/
    this.getDataList();
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
                Map item = dataList[index];

                return InkWell(
                  onTap: () {
                    print(item);
                  },
                  child: ListTile(
                    leading: Icon(myIcon['bell']),
                    title: Text(
                      "${item['name']}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "${item['addtime']}",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: item['status'] == 1
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

  /*请求数据*/
  void getDataList() async {
    try {
      var result = await myRequest(path: "/api/system/systemInfo");
      List data = result['data'];
      List newData = data.map((e) {
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(e['addtime'] * 1000); //开始时间

        String addtime =
            formatDate(time, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);

        return {
          "id": e['id'], //id
          "name": e['name'], //标题
          "addtime": addtime, //时间
          "status": e['status'], //状态, 1已读 2未读
          "content": e['content'], //通知的内容
          "type": e['type'], //type==2 跳转到咨询详情
          "link_id": e['link_id'], //咨询详情id
          "annex": e['annex'], //文件地址
          "link": e['link'], //外部链接
        };
      }).toList();

      setState(() {
        dataList = newData;
      });
    } catch (e) {
      print(e);
    }
  }
}
