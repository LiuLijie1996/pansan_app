import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './router.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

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
    );
  }
}
