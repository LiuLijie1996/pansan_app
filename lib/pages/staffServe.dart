// 职工服务页面

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../components/MyProgress.dart';
import '../components/EmptyBox.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../utils/fileMethod.dart';
import '../models/CertificateDataType.dart'; //证书类型
import '../models/IllegalManageDataType.dart'; //三违情况类型
import '../models/AdvisoryDataType.dart'; //咨询类型
import '../utils/ErrorInfo.dart';

class StaffServe extends StatefulWidget {
  StaffServe({Key key}) : super(key: key);

  @override
  _StaffServeState createState() => _StaffServeState();
}

class _StaffServeState extends State<StaffServe>
    with MyScreenUtil, SingleTickerProviderStateMixin {
  TabController _tabController; //导航控制器
  TextEditingController _inputController = TextEditingController(); //输入框控制器
  String inputValue = '';

  List tabs = [
    {
      "id": 2,
      "title": "持证情况",
    },
    {
      "id": 3,
      "title": "三违情况",
    },
    {
      "id": 1,
      "title": "咨询",
    },
  ];

  List data = [];
  int page = 1;
  int psize = 20;
  int total = 0;
  bool isInital = false; //初始化是否完成

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitial();
  }

  // 初始化
  myInitial() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        data = [];
        page = 1;
        psize = 20;
        // 请求数据
        getDataList(id: tabs[_tabController.index]['id']);
      }
    });

    // 请求数据
    getDataList(id: tabs[0]['id']);
  }

  // 请求数据
  getDataList({
    @required id,
  }) async {
    try {
      var result = await myRequest(
        path: MyApi.getUserServiceList,
        data: {
          "pid": id,
          "page": page,
          "psize": psize,
          "title": inputValue,
        },
      );
      total = result['total'];
      List resultData = result['data'];
      List newData = resultData.map((e) {
        if (_tabController.index == 0) {
          // 证书
          return CertificateDataType.fromJson({
            "id": int.parse("${e['id']}"),
            "idCard": e['idCard'],
            "name": e['name'],
            "dep": e['dep'],
            "addtime": int.parse("${e['addtime']}"),
          });
        } else if (_tabController.index == 1) {
          // 三违情况
          return IllegalManageDataType.fromJson({
            "id": int.parse("${e['id']}"),
            "pid": int.parse("${e['pid']}"),
            "title": e['title'],
            "link": e['link'],
            "addtime": int.parse("${e['addtime']}"),
          });
        } else {
          // 咨询
          return AdvisoryDataType.fromJson({
            "id": int.parse("${e['id']}"),
            "pid": int.parse("${e['pid']}"),
            "title": e['title'],
            "content": e['content'],
            "addtime": int.parse("${e['addtime']}"),
          });
        }
      }).toList();

      if (this.mounted) {
        setState(() {
          inputValue = '';
          data.addAll(newData);
          isInital = true;
        });
      }
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "获取数据失败",
        path: MyApi.getUserServiceList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInital) {
      return Scaffold(
        body: MyProgress(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: dp(80.0),
          child: TextField(
            controller: _inputController,
            onChanged: (value) {
              inputValue = value;
            },
            decoration: InputDecoration(
              hintText: '请输入你要搜索的内容',
              fillColor: Colors.white,
              filled: true,
              suffixIcon: InkWell(
                onTap: () {
                  data = [];
                  page = 1;
                  psize = 20;
                  // 请求数据
                  getDataList(id: tabs[_tabController.index]['id']);

                  // 清空输入框
                  _inputController.text = '';
                },
                child: Icon(Icons.search),
              ),
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: tabs.map((e) {
            return Tab(
              child: Text("${e['title']}"),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: _tabController.index == 2
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "/addAdvisory");
              },
            )
          : null,
      body: data.length != 0
          ? TabBarView(
              controller: _tabController,
              children: tabs.map((e) {
                if (_tabController.index == 0) {
                  // 持证情况
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      CertificateDataType item;
                      try {
                        item = data[index];
                      } catch (e) {
                        // 如果报错判断是否请求数据
                        if (total == data.length) {
                          return MyProgress(status: false);
                        }

                        ++page;
                        getDataList(id: tabs[_tabController.index]['id']);
                        return MyProgress();
                      }

                      return CertificateWidget(item: item);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: data.length + 1,
                  );
                } else if (_tabController.index == 1) {
                  // 三违情况
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      IllegalManageDataType item;
                      try {
                        item = data[index];
                      } catch (e) {
                        // 如果报错判断是否请求数据
                        if (total == data.length) {
                          return MyProgress(status: false);
                        }

                        ++page;
                        getDataList(id: tabs[_tabController.index]['id']);
                        return MyProgress();
                      }
                      return IllegalManageWidget(item: item);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: data.length + 1,
                  );
                }

                // 咨询
                return ListView.separated(
                  itemBuilder: (context, index) {
                    AdvisoryDataType item;
                    try {
                      item = data[index];
                    } catch (e) {
                      // 如果报错判断是否请求数据
                      if (total == data.length) {
                        return MyProgress(status: false);
                      }

                      ++page;
                      getDataList(id: tabs[_tabController.index]['id']);
                      return MyProgress();
                    }
                    return AdvisoryWidget(item: item);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: data.length + 1,
                );
              }).toList(),
            )
          : EmptyBox(),
    );
  }
}

// 证书情况组件
class CertificateWidget extends StatelessWidget with MyScreenUtil {
  CertificateDataType item;
  CertificateWidget({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("${item.name}"),
      title: Container(
        height: dp(100.0),
        alignment: Alignment.center,
        child: Text("${item.dep}"),
      ),
      trailing: RaisedButton(
        color: Colors.blue,
        child: Text(
          '查看',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          // 跳转到证书详情页面
          Navigator.pushNamed(
            context,
            "/certificateDetail",
            arguments: item,
          );
        },
      ),
    );
  }
}

// 三违情况组件
class IllegalManageWidget extends StatelessWidget with MyScreenUtil {
  IllegalManageDataType item;
  IllegalManageWidget({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      item.addtime * 1000,
    );
    // 时间转换
    var _addtime = formatDate(
      addtime,
      [yyyy, '-', mm, '-', dd],
    );

    return ListTile(
      onTap: () {
        // 预览文件
        FilePreview(
          context: context,
          link: item.link,
          title: item.title,
        );
      },
      leading: Text("${item.title}"),
      trailing: Text("$_addtime"),
    );
  }
}

// 咨询组件
class AdvisoryWidget extends StatelessWidget with MyScreenUtil {
  AdvisoryDataType item;
  AdvisoryWidget({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      item.addtime * 1000,
    );
    // 时间转换
    var _addtime = formatDate(
      addtime,
      [yyyy, '-', mm, '-', dd],
    );

    return ListTile(
      onTap: () {
        // 跳转到咨询详情
        Navigator.pushNamed(
          context,
          '/advisoryDetail',
          arguments: item.toJson(),
        );
      },
      leading: Container(
        width: dp(350),
        child: Text(
          "${item.title}",
          maxLines: 2,
        ),
      ),
      trailing: Text("$_addtime"),
    );
  }
}
