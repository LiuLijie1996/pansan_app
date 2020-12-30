// 个人信息
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';

class MyInformation extends StatefulWidget {
  MyInformation({Key key}) : super(key: key);

  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> with MyScreenUtil {
  PickedFile _image;

  /*打开相册*/
  _openGallery() async {
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.gallery, // 打开相册
    );
    setState(() {
      _image = image ?? _image;
    });

    try {
      // 上传文件
      var result = await dioUpload(
        path: MyApi.upload,
        filePath: image.path,
      );
      print(result);
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "上传失败",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人资料"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: dp(300.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                height: dp(220.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: dp(80.0),
                      backgroundImage: _image != null
                          ? AssetImage(_image.path)
                          : NetworkImage(
                              "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2725210985,2088815523&fm=26&gp=0.jpg",
                            ),
                    ),
                    SizedBox(
                      height: dp(20.0),
                    ),
                    InkWell(
                      onTap: _openGallery,
                      child: Text(
                        "更换头像",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: dp(26.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: dp(20.0),
            ),
            Container(
              color: Colors.white,
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.grey),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("姓名"),
                          Text("小明"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("性别"),
                          Text("男"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("身份证号"),
                          Text("123456789987456321"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("职工编号"),
                          Text("123456"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("部门"),
                          Text("技术测试部门"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("最高学历"),
                          Text("博士"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("参加工作时间"),
                          Text("2020-01-01"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("现技能等级"),
                          Text("100"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("专业技术资格"),
                          Text("巴拉巴拉"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("现职业工种"),
                          Text("巴拉巴拉"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("岗位工种"),
                          Text("巴拉巴拉"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("职衔"),
                          Text("巴拉巴拉"),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: dp(30.0),
                        bottom: dp(30.0),
                        left: dp(20.0),
                        right: dp(20.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: dp(0.6),
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
