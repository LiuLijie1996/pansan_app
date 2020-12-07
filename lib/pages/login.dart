import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/utils/myRequest.dart';

// 登录页面
class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController(); //输入框使用到的控制器
  TextEditingController _controller2 = TextEditingController(); //输入框使用到的控制器
  bool _obscureText = true;

  String account = ''; //输入的账号
  String pwd = ''; //输入的密码

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100.0,
              ),
              Image.asset(
                "assets/images/login_logo.png",
                width: 120.0,
                height: 120.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10, //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(3.0),
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
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10, //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(3.0),
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
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        top: 20.0,
                        bottom: 20.0,
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
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Text(
                          "立即登录",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        color: account == ''
                            ? Colors.grey
                            : pwd == ''
                                ? Colors.grey
                                : Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (account != '') {
                            if (pwd != '') {
                              var result = await myRequest(
                                path: "/api/login",
                                data: {"account": account, "pwd": pwd},
                              );
                              print(result);
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
}

// 注册页面
class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController(); //输入框使用到的控制器
  TextEditingController _controller2 = TextEditingController(); //输入框使用到的控制器

  String phone = ''; //输入的手机号
  String verifyCode = ''; //输入的验证码
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
  }

  @override
  void dispose() {
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
                height: 50.0,
              ),
              Image.asset(
                "assets/images/login_logo.png",
                width: 120.0,
                height: 120.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10, //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0.0),
                          controller: _controller1,
                          decoration: InputDecoration(
                            hintText: "请输入手机号码",
                            border: InputBorder.none,
                            prefixIcon: Icon(myIcon['phone']),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10, //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(3.0),
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
                              onPressed: () {
                                if (_verifyBtn == false) {
                                  print("获取验证码");
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
                                      print(_count);

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
                              size: 20.0,
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
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Text(
                          "立即注册",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        color: phone == ''
                            ? Colors.grey
                            : verifyCode == ''
                                ? Colors.grey
                                : Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (phone != '') {
                            if (verifyCode != '') {
                              var result = await myRequest(
                                path: "/api/login",
                                data: {
                                  "phone": phone,
                                  "verifyCode": verifyCode
                                },
                              );
                              print(result);
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
}

// 忘记密码
class ForgetPwd extends StatefulWidget {
  ForgetPwd({Key key}) : super(key: key);

  @override
  _ForgetPwdState createState() => _ForgetPwdState();
}

class _ForgetPwdState extends State<ForgetPwd> {
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
                height: 50.0,
              ),
              Image.asset(
                "assets/images/login_logo.png",
                width: 120.0,
                height: 120.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10, //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(3.0),
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
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10, //阴影范围
                              spreadRadius: 0.1, //阴影浓度
                              color: Colors.blue[100], //阴影颜色
                            ),
                          ],
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: TextFormField(
                          controller: _controller2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入身份证号码",
                            prefixIcon: Icon(
                              myIcon['id_card'],
                              size: 20.0,
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
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Text(
                          "重置密码",
                          style: TextStyle(fontSize: 16.0),
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
                              var result = await myRequest(
                                path: "/api/login",
                                data: {"userName": userName, "idCard": idCard},
                              );
                              print(result);
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
}
