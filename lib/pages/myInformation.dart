// 个人信息
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/MyProgress.dart';
import '../models/UserInfoDataType.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';
import '../db/UserDB.dart';

class MyInformation extends StatefulWidget {
  MyInformation({Key key}) : super(key: key);

  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation>
    with MyScreenUtil, UserInfoMixin {
  _MyInformationState() {
    // 获取用户信息
    this.userInfo();
  }

  // 用户信息
  UserInfoDataType user;

  @override
  // TODO: implement userInfo
  Future<UserInfoDataType> userInfo() async {
    user = await super.userInfo();
    if (this.mounted) {
      setState(() {});
    }
  }

  /*打开相册*/
  _openGallery() async {
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.gallery, // 打开相册
    );

    if (image == null) return;

    try {
      var myRequest = MyRequest(line: true).request;

      // 上传头像
      var result = await myRequest(
        path: MyApi.upload,
        filePath: image.path,
      );

      // 获取后台返回的图片地址
      var photo = result['data']['link'];

      // 修改本地数据库的用户信息
      user.headUrl = photo;
      UserDB.update(user);

      // 刷新页面
      if (this.mounted) {
        setState(() {});
      }

      // 得到返回的头像地址，上传给后台
      var reault = await myRequest(
        path: MyApi.editUser,
        data: {
          "user_id": true,
          "headUrl": photo,
        },
      );

      // 弹窗提示
      Fluttertoast.showToast(
        msg: "${reault['msg']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      ErrorInfo(
        errInfo: e,
        msg: "上传失败",
        path: MyApi.upload,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: MyProgress(),
      );
    }
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
                      backgroundImage: NetworkImage(
                        "${user.headUrl != null ? user.headUrl : 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2725210985,2088815523&fm=26&gp=0.jpg'}",
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
                          Text("${user.name}"),
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
                          Text("${user.sex == 1 ? '男' : '女'}"),
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
                          Text("${user.idCard}"),
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
                          Text("${user.no != null ? user.no : ''}"),
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
                          Text("${user.department}"),
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
                          Text(
                            "${user.education != null ? user.education : ''}",
                          ),
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
                          Text("${user.jobtime != null ? user.jobtime : ''}"),
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
                          Text(
                            "${user.skillLevel != null ? user.skillLevel : ''}",
                          ),
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
                          Text("${user.title != null ? user.title : ''}"),
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
                          Text("${user.typeWork != null ? user.typeWork : ''}"),
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
                          Text("${user.jobWork != null ? user.jobWork : ''}"),
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
                          Text("${user.job != null ? user.job : ''}"),
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
