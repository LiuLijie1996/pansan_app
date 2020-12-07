import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/utils/myRequest.dart';

class UpdatePwd extends StatefulWidget {
  UpdatePwd({Key key}) : super(key: key);

  @override
  _UpdatePwdState createState() => _UpdatePwdState();
}

class _UpdatePwdState extends State<UpdatePwd> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController(); //输入框使用到的控制器
  TextEditingController _controller2 = TextEditingController(); //输入框使用到的控制器
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  String pwd1 = ''; //输入的密码
  String pwd2 = ''; //输入的密码

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller1.addListener(() {
      setState(() {
        pwd1 = _controller1.text.trim();
      });
    });
    _controller2.addListener(() {
      setState(() {
        pwd2 = _controller2.text.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码"),
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
                // autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          obscureText: _obscureText1,
                          // validator: (String value){
                          //   print("${value.trim().length}");
                          //   return value.trim().length >= 6 ? null : '密码长度最少6位';
                          // },
                          decoration: InputDecoration(
                            hintText: "请输入新密码",
                            suffixIcon: InkWell(
                              child: Icon(
                                _obscureText1 == true
                                    ? myIcon['eye-off']
                                    : myIcon['eye-open'],
                              ),
                              onTap: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              myIcon['pwd'],
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: validatorPwd1() == '' ? 20.0 : 30.0,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 20.0),
                      child: Text(
                        "${validatorPwd1()}",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
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
                          obscureText: _obscureText2,
                          // validator: (String value){
                          //   return value.trim() == pwd1 ? null : "两次密码不一致";
                          // },
                          decoration: InputDecoration(
                            hintText: "请再次输入密码",
                            suffixIcon: InkWell(
                              child: Icon(
                                _obscureText2 == true
                                    ? myIcon['eye-off']
                                    : myIcon['eye-open'],
                              ),
                              onTap: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              myIcon['pwd'],
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: validatorPwd2() == '' ? 20.0 : 30.0,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 20.0),
                      child: Text(
                        "${validatorPwd2()}",
                        style: TextStyle(
                          color: Colors.red,
                        ),
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
                          "确认修改",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        color: pwd1 == ''
                            ? Colors.grey
                            : pwd2 != pwd1
                                ? Colors.grey
                                : Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (pwd1 != '') {
                            if (pwd1 == pwd2) {
                              var result = await myRequest(
                                path: "/api/login",
                                data: {"pwd1": pwd1, "pwd2": pwd2},
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

  String validatorPwd1(){
    if(pwd1.trim() != null){
      if(pwd1.trim() != ''){
        return pwd1.trim().length >= 6 ? '' : '密码长度最少6位';
      }else{
        return "";
      }
    }else{
      return "";
    }
  }
  String validatorPwd2(){
    if(pwd2.trim() != null){
      if(pwd2.trim() != ''){
        return pwd2.trim() == pwd1.trim() ? '' : '两次密码不一致';
      }else{
        return "";
      }
    }else{
      return "";
    }
  }
}
