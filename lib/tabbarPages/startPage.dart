import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3)).then((value) {
          print("到时间了");
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => route == null,
          );
        });
      }
    });

    // 开启动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(750, 1280),
      allowFontScaling: false,
    );
    return FadeTransition(
      opacity: _controller,
      child: Image.asset(
        "assets/images/start_image.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
