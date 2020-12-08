// 我的错题

import 'package:flutter/material.dart';
import 'package:pansan_app/components/EmptyBox.dart';

class MyMistakes extends StatefulWidget {
  MyMistakes({Key key}) : super(key: key);

  @override
  _MyMistakesState createState() => _MyMistakesState();
}

class _MyMistakesState extends State<MyMistakes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的错题"),
        centerTitle: true,
      ),
      body: EmptyBox(),
    );
  }
}
