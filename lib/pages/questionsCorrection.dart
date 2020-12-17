// 试题纠错

import 'package:flutter/material.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/examIssueType.dart';

class QuestionsCorrection extends StatefulWidget {
  final ExamIssueDataType issueData;
  QuestionsCorrection({Key key, this.issueData}) : super(key: key);

  @override
  _QuestionsCorrectionState createState() => _QuestionsCorrectionState();
}

class _QuestionsCorrectionState extends State<QuestionsCorrection>
    with MyScreenUtil {
  List<String> errTyle = ['题干错误', '看不懂题', '题目错误', '图片看不清'];
  int _currentErrIndex = 0;
  String _inputValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExamIssueDataType issueData = widget.issueData;

    return Scaffold(
      appBar: AppBar(
        title: Text("纠错"),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: dp(40.0),
          bottom: dp(20.0),
          left: dp(20.0),
          right: dp(20.0),
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: dp(40.0)),
              child: Text(
                "报错类型",
                style: TextStyle(
                  fontSize: dp(36.0),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            // 选择错误类型
            Wrap(
              spacing: dp(20.0),
              children: errTyle.map((e) {
                int index = errTyle.indexOf(e);
                return InkWell(
                  onTap: () {
                    setState(() {
                      _currentErrIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: dp(20.0),
                      bottom: dp(20.0),
                      left: dp(15.0),
                      right: dp(15.0),
                    ),
                    decoration: BoxDecoration(
                      color: _currentErrIndex == index
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        color: _currentErrIndex == index
                            ? Colors.white
                            : Colors.black,
                        fontSize: dp(26.0),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // 备注
            Container(
              margin: EdgeInsets.only(top: dp(50.0), bottom: dp(40.0)),
              child: Text(
                "备注",
                style: TextStyle(
                  fontSize: dp(36.0),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '你的耐心指点，是我们前进的动力',
                hintStyle: TextStyle(fontSize: dp(28.0)),
                contentPadding: EdgeInsets.all(dp(20.0)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _inputValue = value;
                });
              },
            ),

            Container(
              margin: EdgeInsets.only(top: dp(50.0)),
              padding: EdgeInsets.only(left: dp(50.0), right: dp(50.0)),
              child: SizedBox(
                child: RaisedButton(
                  onPressed: () {
                    Map data = {
                      "err_type": _currentErrIndex,
                      "content": _inputValue,
                    };
                    print(data);

                    Navigator.pop(context, data);
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "提交",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
