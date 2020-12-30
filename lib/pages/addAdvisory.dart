// 添加咨询

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../mixins/withScreenUtil.dart';
import '../utils/myRequest.dart';
import '../utils/ErrorInfo.dart';

class AddAdvisory extends StatefulWidget {
  AddAdvisory({Key key}) : super(key: key);

  @override
  _AddAdvisoryState createState() => _AddAdvisoryState();
}

class _AddAdvisoryState extends State<AddAdvisory> with MyScreenUtil {
  GlobalKey _formKey = GlobalKey<FormState>(); // 表单的key
  TextEditingController _titleController =
      TextEditingController(); //标题输入框使用到的控制器
  TextEditingController _textController =
      TextEditingController(); //文本输入框使用到的控制器

  String _title;
  String _text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加咨询"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 标题输入框
              Container(
                padding: EdgeInsets.only(left: dp(10.0)),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    icon: Container(
                      width: dp(150.0),
                      alignment: Alignment.centerRight,
                      child: Text("标题"),
                    ),
                    hintText: "请输入标题",
                  ),
                  onSaved: (newValue) => this._title = newValue,
                  validator: (String value) {
                    return value.trim().length == 0 ? "标题不能为空" : null;
                  },
                ),
              ),

              // 咨询内容
              Container(
                padding: EdgeInsets.only(left: dp(10.0)),
                child: TextFormField(
                  maxLines: null,
                  controller: _textController,
                  decoration: InputDecoration(
                    icon: Container(
                      width: dp(150.0),
                      alignment: Alignment.centerRight,
                      child: Text("咨询内容"),
                    ),
                    hintText: "请输入需要咨询的问题详情",
                  ),
                  onSaved: (newValue) => this._text = newValue,
                  validator: (String value) {
                    return value.trim().length == 0 ? "内容不能为空" : null;
                  },
                ),
              ),

              SizedBox(height: dp(20.0)),

              RaisedButton(
                child: Text("提交"),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  FormState form = _formKey.currentState;
                  // (_formKey.currentState as FormState).validate() 触发验证，返回布尔值
                  if (form.validate()) {
                    var query = {
                      "user_id": true,
                      "pid": 1,
                      "title": _titleController.text,
                      "content": _textController.text,
                    };

                    try {
                      // 发送数据给后台
                      var result = await myRequest(
                        context: context,
                        path: MyApi.addUserService,
                        data: query,
                      );

                      // 如果返回null说明已经跳转到登录页了，没有任何数据返回
                      if (result == null) return;

                      Fluttertoast.showToast(
                        msg: "${result['msg']}",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } catch (err) {
                      ErrorInfo(
                        context: context,
                        errInfo: err,
                        msg: "添加失败：$err",
                      );
                    }

                    // 返回
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
