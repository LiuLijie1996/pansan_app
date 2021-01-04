import 'package:flutter/material.dart';

class LoadWidget {
  bool isLoad = false;
  GlobalKey<TextWidgetState> _key = GlobalKey();

  // 显示加载框
  showLoad(BuildContext context, {String msg}) async {
    if (!isLoad) {
      print("显示加载框：$isLoad");
      isLoad = true;
      await showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return Future(() => false);
            },
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Center(
                    child: TextWidget(key: _key),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      _key?.currentState?.onPressed(msg: msg);
    }
  }

  // 隐藏加载框
  hideLoad(BuildContext context) {
    print("隐藏加载框：$isLoad");
    Navigator.pop(context);
    isLoad = false;
  }
}

class TextWidget extends StatefulWidget {
  TextWidget({Key key}) : super(key: key);

  @override
  TextWidgetState createState() => TextWidgetState();
}

class TextWidgetState extends State<TextWidget> {
  String msg = "0%";

  @override
  Widget build(BuildContext context) {
    return Text(
      "$msg",
    );
  }

  onPressed({String msg}) {
    setState(() {
      this.msg = msg;
    });
  }
}
