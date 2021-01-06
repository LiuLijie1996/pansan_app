import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './router.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

// 推送测试
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter/services.dart';
// import 'package:mobpush_plugin/mobpush_plugin.dart';
// import 'package:mobpush_plugin/mobpush_custom_message.dart';
// import 'package:mobpush_plugin/mobpush_notify_message.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: MainApp(),
//     );
//   }
// }

// class MainApp extends StatefulWidget {
//   @override
//   _MainAppState createState() {
//     return _MainAppState();
//   }
// }

// class _MainAppState extends State<MainApp> {
//   String _sdkVersion = 'Unknown';
//   String _registrationId = 'Unknown';

//   @override
//   void initState() {
//     super.initState();

//     initPlatformState();

//     if (Platform.isIOS) {
//       MobpushPlugin.setCustomNotification();
//       MobpushPlugin.setAPNsForProduction(false);
//     }
//     MobpushPlugin.addPushReceiver(_onEvent, _onError);

//     //上传隐私协议许可
//     MobpushPlugin.updatePrivacyPermissionStatus(true);
//   }

//   void _onEvent(Object event) {
//     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onEvent:' + event.toString());
//     setState(() {
//       Map<String, dynamic> eventMap = json.decode(event);
//       Map<String, dynamic> result = eventMap['result'];
//       int action = eventMap['action'];

//       switch (action) {
//         case 0:
//           MobPushCustomMessage message =
//               new MobPushCustomMessage.fromJson(result);
//           showDialog(
//               context: context,
//               child: AlertDialog(
//                 content: Text(message.content),
//                 actions: <Widget>[
//                   FlatButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text("确定"),
//                   )
//                 ],
//               ));
//           break;
//         case 1:
//           MobPushNotifyMessage message =
//               new MobPushNotifyMessage.fromJson(result);
//           break;
//         case 2:
//           MobPushNotifyMessage message =
//               new MobPushNotifyMessage.fromJson(result);
//           break;
//       }
//     });
//   }

//   void _onError(Object event) {
//     setState(() {
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onError:' + event.toString());
//     });
//   }

//   Future<void> initPlatformState() async {
//     String sdkVersion;

//     try {
//       sdkVersion = await MobpushPlugin.getSDKVersion();
//     } on PlatformException {
//       sdkVersion = 'Failed to get platform version.';
//     }
//     try {
//       MobpushPlugin.getRegistrationId().then((Map<String, dynamic> ridMap) {
//         print(ridMap);
//         setState(() {
//           _registrationId = ridMap['res'].toString();
//           print('------>#### registrationId: ' + _registrationId);
//         });
//       });
//     } on PlatformException {
//       _registrationId = 'Failed to get registrationId.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _sdkVersion = sdkVersion;
//     });
//   }

//   // 复制到剪切板
//   void _onCopyButtonClicked() {
//     // 写入剪切板
//     Clipboard.setData(ClipboardData(text: _registrationId));
//     // 验证是否写入成功
//     Clipboard.getData(Clipboard.kTextPlain).then((data) {
//       String text = data.text;
//       print('------>#### copyed registrationId: $text');
//       if (text == _registrationId) {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("恭喜🎉"),
//                 content: Container(
//                   margin: EdgeInsets.only(top: 10, bottom: 30),
//                   child: Text('复制成功！'),
//                 ),
//                 actions: <Widget>[
//                   new FlatButton(
//                     child: new Text("OK"),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   )
//                 ],
//               );
//             });
//       }
//     });
//   }

//   ///测试推送
//   testPush() {
//     /**
//     * 测试模拟推送，用于测试
//     * type（int）：模拟消息类型，1、通知测试；2、内推测试；3、定时
//     * content（String）：模拟发送内容，500字节以内，UTF-8
//     * space（int）：仅对定时消息有效，单位分钟，默认1分钟
//     * extras（String）: 附加数据，json字符串
//     */
//     MobpushPlugin.send(
//       1,
//       "模拟发送内容，500字节以内，UTF-8",
//       1,
//       "{id:1}",
//     ).then((Map<String, dynamic> sendMap) {
//       print("测试推送：$sendMap");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('MobPushPlugin Demo'),
//         ),
//         body: ListView(
//           children: <Widget>[
//             Text(
//               'SDK Version: $_sdkVersion\nRegistrationId: $_registrationId',
//               style: TextStyle(fontSize: 12),
//             ),
//             RaisedButton(
//               child: Text('复制'),
//               onPressed: _onCopyButtonClicked,
//             ),
//             RaisedButton(
//               child: Text('测试推送'),
//               onPressed: testPush,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
