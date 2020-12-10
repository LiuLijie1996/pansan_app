// 添加咨询

import 'package:flutter/material.dart';
import 'package:pansan_app/utils/myRequest.dart';

class AddAdvisory extends StatefulWidget {
  AddAdvisory({Key key}) : super(key: key);

  @override
  _AddAdvisoryState createState() => _AddAdvisoryState();
}

class _AddAdvisoryState extends State<AddAdvisory> {
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
                padding: EdgeInsets.only(left: 5.0),
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //       color: Colors.grey,
                //       width: 0.5,
                //     ),
                //   ),
                // ),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    icon: Container(
                      width: 60.0,
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
                padding: EdgeInsets.only(left: 5.0),
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //       color: Colors.grey,
                //       width: 0.5,
                //     ),
                //   ),
                // ),
                child: TextFormField(
                  maxLines: null,
                  controller: _textController,
                  decoration: InputDecoration(
                    icon: Container(
                      width: 60.0,
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

              SizedBox(height: 10.0),

              RaisedButton(
                child: Text("提交"),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  FormState form = _formKey.currentState;
                  // (_formKey.currentState as FormState).validate() 触发验证，返回布尔值
                  if (form.validate()) {
                    var query = {
                      "user_id": "用户id",
                      "title": _titleController.text,
                      "content": _textController.text,
                    };

                    // 发送数据给后台
                    var result = await myRequest(
                      path: "/api/login",
                      data: query,
                    );

                    print(result);
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
