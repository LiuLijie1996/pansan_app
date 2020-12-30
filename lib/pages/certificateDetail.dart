// 证书详情

import 'package:flutter/material.dart';
import '../models/CertificateDataType.dart';
import '../models/CertificateDetailDataType.dart';
import '../utils/myRequest.dart';
import '../mixins/withScreenUtil.dart';

class CertificateDetail extends StatefulWidget {
  final CertificateDataType arguments;
  CertificateDetail({Key key, @required this.arguments}) : super(key: key);

  @override
  _CertificateDetailState createState() => _CertificateDetailState();
}

class _CertificateDetailState extends State<CertificateDetail>
    with MyScreenUtil {
  bool isInitialize = false; //初始化是否完成
  List<CertificateDetailDataType> detailData = []; //证书详情

  @override
  void initState() {
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() {
    // 获取证书详情数据
    getUserCert();
  }

  // 获取证书详情数据
  getUserCert() async {
    try {
      var result = await myRequest(
        path: MyApi.getUserCert,
        data: {
          "idCard": widget.arguments.idCard,
        },
      );

      List data = result['data'];
      detailData = data.map((e) {
        return CertificateDetailDataType.fromJson({
          "id": e['id'],
          "pid": e['pid'],
          "dep": e['dep'],
          "name": e['name'],
          "cert_name": e['cert_name'],
          "cert_no": e['cert_no'],
          "idCard": e['idCard'],
          "time": e['time'],
          "major_type": e['major_type'],
          "major_level": e['major_level'],
          "tech_level": e['tech_level'],
          "valid_start_time": e['valid_start_time'],
          "valid_end_time": e['valid_end_time'],
          "reexamine_time": e['reexamine_time'],
          "mechanism": e['mechanism'],
          "id_photo_1": e['id_photo_1'],
          "id_photo_2": e['id_photo_2'],
          "addtime": e['addtime'],
          "status": e['status'],
          "time2": e['time2'],
        });
      }).toList();

      if (this.mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String idCard = widget.arguments.idCard;
    String _idCard = idCard.substring(0, 6) + "******" + idCard.substring(13);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.arguments.name}的证书详情"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: dp(20.0),
              right: dp(20.0),
              top: dp(30.0),
              bottom: dp(30.0),
            ),
            margin: EdgeInsets.all(dp(20.0)),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(dp(10.0))),
            child: Text(
              "姓名：${widget.arguments.name}   身份证号：$_idCard",
              style: TextStyle(
                fontSize: dp(30.0),
                color: Colors.white,
              ),
            ),
          ),
          Column(
            children: detailData.map((e) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: dp(20.0),
                  left: dp(20.0),
                  right: dp(20.0),
                ),
                child: CertificateWidget(item: e),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// 证书卡片组件
class CertificateWidget extends StatelessWidget with MyScreenUtil {
  final CertificateDetailDataType item;
  const CertificateWidget({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dp(20.0)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dp(10.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: dp(10.0),
              color: Colors.grey[300],
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("证书名称：${item.certName}"),
          SizedBox(height: dp(60.0)),
          Text("培复训时间：${item.time2}"),
        ],
      ),
    );
  }
}
