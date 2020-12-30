import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import './router.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  // 上次点击返回的时间
  int preTime = new DateTime.now().millisecondsSinceEpoch;
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
      child: MaterialApp(
        title: "潘三学习平台",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/", //默认显示的路由
        onGenerateRoute: onGenerateRoute, //路由匹配
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
        localeListResolutionCallback:
            (List<Locale> locales, Iterable<Locale> supportedLocales) {
          return Locale('zh');
        },
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          return Locale('zh');
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      ),
    );
  }
}
