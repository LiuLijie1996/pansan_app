import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/MyIcon.dart';
import '../utils/ErrorInfo.dart';
import '../mixins/mixins.dart';
import '../utils/myRequest.dart';
import '../models/UserInfoDataType.dart';
import '../db/UserDB.dart';

/// 登录页面
class Login extends StatefulWidget {
  static BuildContext context;
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with MyScreenUtil {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController(); //输入框使用到的控制器
  TextEditingController _controller2 = TextEditingController(); //输入框使用到的控制器
  bool _obscureText = true;

  String account = ''; //输入的账号
  String pwd = ''; //输入的密码

  // 上次点击返回的时间
  int preTime = new DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化
    myInitialize();
  }

  // 初始化
  myInitialize() async {
    // 删除数据库
    await UserDB.delete();
    // 关闭数据库
    UserDB.dispose();

    // 输入框控制器
    _controller1.addListener(() {
      setState(() {
        account = _controller1.text;
      });
    });
    _controller2.addListener(() {
      setState(() {
        pwd = _controller2.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int currenTime = new DateTime.now().millisecondsSinceEpoch;

        // 点击返回键的操作
        if (currenTime - preTime > 500) {
          preTime = currenTime;
          Fluttertoast.showToast(
            msg: "你今天真好看",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: dp(200.0),
                ),
                Image.asset(
                  "assets/images/login_logo.png",
                  width: dp(240.0),
                  height: dp(240.0),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: dp(40.0),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: dp(20.0), //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.blue[100], //阴影颜色
                              ),
                            ],
                            borderRadius: BorderRadius.circular(dp(6.0)),
                          ),
                          child: TextFormField(
                            scrollPadding: EdgeInsets.all(0.0),
                            controller: _controller1,
                            decoration: InputDecoration(
                              hintText: "请输入身份证号码",
                              border: InputBorder.none,
                              // border: OutlineInputBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(50.0)),
                              //   borderSide: BorderSide(
                              //     width: 0.5,
                              //     color: Colors.grey[100],
                              //   ),
                              // ),
                              prefixIcon: Icon(
                                Icons.person,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: dp(40.0),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: dp(20.0), //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.blue[100], //阴影颜色
                              ),
                            ],
                            borderRadius: BorderRadius.circular(dp(6.0)),
                          ),
                          child: TextFormField(
                            controller: _controller2,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              hintText: "请输入密码",
                              suffixIcon: InkWell(
                                child: Icon(
                                  _obscureText == true
                                      ? myIcon['eye-off']
                                      : myIcon['eye-open'],
                                ),
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              // border: OutlineInputBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(50.0)),
                              //   borderSide: BorderSide(
                              //     width: 0.5,
                              //     color: Colors.grey[100],
                              //   ),
                              // ),
                              prefixIcon: Icon(
                                myIcon['pwd'],
                                size: dp(40.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: dp(60.0),
                          right: dp(60.0),
                          top: dp(40.0),
                          bottom: dp(40.0),
                        ),
                        // padding: EdgeInsets.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Text("注册账号"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Register();
                                    },
                                  ),
                                );
                              },
                            ),
                            InkWell(
                              child: Text("忘记密码"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ForgetPwd();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                        child: RaisedButton(
                          padding: EdgeInsets.all(dp(20.0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(dp(6.0)),
                          ),
                          child: Text(
                            "立即登录",
                            style: TextStyle(fontSize: dp(32.0)),
                          ),
                          color: account == ''
                              ? Colors.grey
                              : pwd == ''
                                  ? Colors.grey
                                  : Colors.blue,
                          textColor: Colors.white,
                          onPressed: isLogin,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 登录
  isLogin() async {
    try {
      if (account == '') {
        myShowToast(msg: "账号不能为空");
        return;
      }
      if (pwd == '') {
        myShowToast(msg: "密码不能为空");
        return;
      }

      // 请求登录
      var result = await myRequest(
        path: MyApi.login,
        data: {
          "username": account,
          "password": pwd,
        },
      );

      if (result['code'] == 0) {
        myShowToast(msg: "${result['msg']}");
        return;
      }

      Map data = result['data'];

      var integral = data['integral'];

      UserInfoDataType userInfo = UserInfoDataType.fromJson({
        "id": data['id'],
        "pid": data['pid'],
        "name": data['name'],
        "password": data['password'],
        "headUrl": data['headUrl'],
        "sex": data['sex'],
        "integral": integral == null ? null : int.parse("$integral"),
        "birthday": data['birthday'],
        "idCard": data['idCard'],
        "No": data['No'],
        "phone": data['phone'],
        "department": data['department'],
        "education": data['education'],
        "title": data['title'],
        "job": data['job'],
        "type_work": data['type_work'],
        "politics_status": data['politics_status'],
        "party_time": data['party_time'],
        "native": data['native'],
        "addtime": data['addtime'],
        "status": data['status'],
        "token": data['token'],
        "expire_time": data['expire_time'],
        "cid": data['cid'],
        "jobtime": data['jobtime'],
        "job_work": data['job_work'],
        "skill_level": data['skill_level'],
        "bindPhone": data['bindPhone'],
      });

      print("存储用户信息：${userInfo.integral}");

      // 存储用户信息
      await UserDB.addData(userInfo);

      // 关闭数据库
      UserDB.dispose();

      myShowToast(msg: '登录成功');

      // 跳转到首页
      Navigator.pushNamed(context, "/home");
    } catch (e) {
      ErrorInfo(
        msg: "登录失败",
        errInfo: e,
        path: MyApi.login,
      );
    }
  }

  myShowToast({@required msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

/// 注册页面
class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with MyScreenUtil {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController(); //输入框使用到的控制器
  TextEditingController _controller2 = TextEditingController(); //输入框使用到的控制器
  TextEditingController _controller3 = TextEditingController(); //输入框使用到的控制器

  String phone = ''; //输入的手机号
  String verifyCode = ''; //输入的验证码
  String idCard; //输入的身份证号
  int _count = 60; //倒计时
  bool _verifyBtn = false; //获取验证码按钮是否被点击了
  Timer _countdownTimer; //定时器

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller1.addListener(() {
      setState(() {
        phone = _controller1.text;
      });
    });
    _controller2.addListener(() {
      setState(() {
        verifyCode = _controller2.text;
      });
    });
    _controller3.addListener(() {
      setState(() {
        idCard = _controller3.text;
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();

    // 清除定时器
    _countdownTimer?.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("注册账号"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: dp(100.0),
              ),
              Image.asset(
                "assets/images/login_logo.png",
                width: dp(240.0),
                height: dp(240.0),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: dp(40.0),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: dp(20.0), //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(dp(6.0)),
                        ),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0.0),
                          controller: _controller1,
                          decoration: InputDecoration(
                            hintText: "请输入手机号码",
                            border: InputBorder.none,
                            prefixIcon: Icon(aliIconfont.phone),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: dp(20.0), //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(dp(6.0)),
                        ),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0.0),
                          controller: _controller3,
                          decoration: InputDecoration(
                            hintText: "请输入身份证号",
                            border: InputBorder.none,
                            prefixIcon: Icon(aliIconfont.id_card),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: dp(20.0), //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(dp(6.0)),
                        ),
                        child: TextFormField(
                          controller: _controller2,
                          decoration: InputDecoration(
                            hintText: "请输入验证码",
                            suffixIcon: RaisedButton(
                              color: Colors.blue,
                              child: Text(
                                _verifyBtn == true ? "$_count s" : "获取验证码",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_verifyBtn == false) {
                                  // 获取验证码
                                  var myRequest = MyRequest(line: true).request;
                                  var result = await myRequest(
                                    path: MyApi.loginCode,
                                    data: {
                                      "phone": phone,
                                      "idCard": idCard,
                                    },
                                  );

                                  myShowToast(msg: "${result['message']}");
                                  if (result['code'] == 0) return;

                                  setState(() {
                                    _verifyBtn = true;
                                  });

                                  // 倒计时
                                  _countdownTimer = Timer.periodic(
                                    Duration(seconds: 1),
                                    (timer) {
                                      setState(() {
                                        _count--;
                                      });
                                      // print(_count);

                                      if (_count <= 0) {
                                        // 清除定时器
                                        _countdownTimer.cancel();
                                        setState(() {
                                          _verifyBtn = false;
                                          _count = 60;
                                        });

                                        print("清除定时器");
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              myIcon['verify'],
                              size: dp(40.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                      child: RaisedButton(
                        padding: EdgeInsets.all(dp(20.0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(dp(6.0)),
                        ),
                        child: Text(
                          "立即注册",
                          style: TextStyle(fontSize: dp(32.0)),
                        ),
                        color: phone == ''
                            ? Colors.grey
                            : verifyCode == ''
                                ? Colors.grey
                                : Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (phone != '') {
                            if (idCard != '') {
                              if (verifyCode != '') {
                                var myRequest = MyRequest(line: true).request;
                                var result = await myRequest(
                                  path: MyApi.register,
                                  data: {
                                    "phone": phone,
                                    "sms_captcha": verifyCode,
                                    "idCard": idCard,
                                  },
                                );
                                myShowToast(msg: "${result['msg']}");
                                Navigator.pop(context);
                              } else {
                                myShowToast(msg: "请输入验证码");
                              }
                            } else {
                              myShowToast(msg: "请输入身份证号码");
                            }
                          } else {
                            myShowToast(msg: "请输入手机号码");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  myShowToast({@required msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// 忘记密码
class ForgetPwd extends StatefulWidget {
  ForgetPwd({Key key}) : super(key: key);

  @override
  _ForgetPwdState createState() => _ForgetPwdState();
}

class _ForgetPwdState extends State<ForgetPwd> with MyScreenUtil {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController(); //输入框使用到的控制器
  TextEditingController _controller2 = TextEditingController(); //输入框使用到的控制器

  String userName = ''; //输入的用户名
  String idCard = ''; //输入的身份证号码

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller1.addListener(() {
      setState(() {
        userName = _controller1.text;
      });
    });
    _controller2.addListener(() {
      setState(() {
        idCard = _controller2.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("忘记密码"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: dp(100.0),
              ),
              Image.asset(
                "assets/images/login_logo.png",
                width: dp(240.0),
                height: dp(240.0),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: dp(20.0), //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(dp(6.0)),
                        ),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0.0),
                          controller: _controller1,
                          decoration: InputDecoration(
                            hintText: "请输入姓名",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: dp(20.0), //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(dp(6.0)),
                        ),
                        child: TextFormField(
                          controller: _controller2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入身份证号码",
                            prefixIcon: Icon(
                              myIcon['id_card'],
                              size: dp(40.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: dp(40.0), right: dp(40.0)),
                      child: RaisedButton(
                        padding: EdgeInsets.all(dp(20.0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(dp(6.0)),
                        ),
                        child: Text(
                          "重置密码",
                          style: TextStyle(fontSize: dp(32.0)),
                        ),
                        color: userName == ''
                            ? Colors.grey
                            : idCard == ''
                                ? Colors.grey
                                : Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (userName != '') {
                            if (idCard != '') {
                              var myRequest = MyRequest(line: true).request;
                              var result = await myRequest(
                                path: MyApi.resetPassWord,
                                data: {
                                  "name": userName,
                                  "idCard": idCard,
                                },
                              );
                              myShowToast(msg: "${result['msg']}");
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  myShowToast({@required msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
