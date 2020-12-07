import 'package:flutter/material.dart';
import './router.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "潘三学习平台",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/", //默认显示的路由
      onGenerateRoute: onGenerateRoute, //路由匹配
    );
  }
}
