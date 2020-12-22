import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pansan_app/components/MyIcon.dart';
import 'package:pansan_app/components/MyProgress.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'package:pansan_app/models/MateriaDataType.dart';
import 'package:video_player/video_player.dart';
import 'package:orientation/orientation.dart';

import 'package:event_bus/event_bus.dart';

// 立即新建一个公共的eventBus
EventBus eventBus = EventBus();

// 定义数据类型
class CustomEvent {
  ///播放进度时间
  int countTime;

  CustomEvent(
    this.countTime,
  );
}

class MyVideoPlayer extends StatefulWidget {
  ///视频信息
  MateriaDataType materia;

  ///视频进度
  int countTime;

  ///是否可以拖动进度条
  bool isSetProgress;
  MyVideoPlayer({
    Key key,
    @required this.materia,
    this.countTime = 0,
    this.isSetProgress = true,
  }) : super(key: key);

  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> with MyScreenUtil {
  StreamSubscription subscription;

  GlobalKey _myKey = new GlobalKey();

  ///是否可以拖动进度条
  bool isSetProgress;

  MateriaDataType materia;
  VideoPlayerController _controller; //视频控制器
  bool _isPlaying = false; //是否播放
  int countTime; //播放进度时间
  Timer _timer; //定时器（计算播放时间）

  Timer _showTimerProgress; //设置进度条消失时间
  bool _isShowProgress = false; //进度条是否显示

  // 手势事件
  var _event;

  @override
  void initState() {
    isSetProgress = widget.isSetProgress;

    materia = widget.materia; //视频信息
    countTime = widget.countTime; //播放进度

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_isPlaying) {
          countTime++;
          if (countTime >= materia.duration) {
            _timer.cancel();
          }
        }
      });
    });

    // 订阅事件（播放时间）
    subscription = eventBus.on<CustomEvent>().listen((event) {
      setState(() {
        countTime = event.countTime;
      });
    });

    _controller = VideoPlayerController.network(materia.link)
      // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});

        // 指定播放位置
        _controller.seekTo(Duration(seconds: countTime));

        // 设置是否显示进度器
        setProgressShow();
      });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // 取消订阅事件
    subscription.cancel();

    _showTimerProgress?.cancel(); //清除定时器
    _timer?.cancel(); //清除定时器
    _controller?.dispose(); //释放播放器资源。

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 判断视频插件是否初始化完成
    if (!_controller.value.initialized) {
      return MyProgress();
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: InkWell(
            onTap: () {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
              setProgressShow();
            },
            child: VideoPlayer(_controller),
          ),
        ),
        // 时间与进度条
        _isShowProgress
            ? Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: dp(15.0),
                    bottom: dp(15.0),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: dp(26.0),
                              ),
                              text: "${setCountTime(countTime)} / ",
                              children: [
                                TextSpan(
                                  text:
                                      "${(materia.duration / 60).toStringAsFixed(2)}",
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        key: _myKey,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            // 点击进度条
                            onPanDown: (DragDownDetails event) {
                              setProgressTime(event);
                            },
                            // 拖动进度条
                            onPanUpdate: (DragUpdateDetails event) {
                              setProgressTime(event);
                            },
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                              value: countTime / materia.duration,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: InkWell(
                            child: Icon(
                              aliIconfont.magnify,
                              color: Colors.white,
                              size: dp(36.0),
                            ),
                            onTap: () async {
                              // 跳转到全屏播放
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FillScreenPlayer(
                                      countTime: countTime,
                                      controller: _controller,
                                      materia: materia,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  void setProgressTime(event) {
    if (isSetProgress) {
      setProgressShow();
      // 当前组件的宽度
      double width = _myKey.currentContext.size.width;
      // 计算出当前进度
      double progress = 0;
      if (event.localPosition.dx >= width) {
        progress = 1.0;
      } else if (event.localPosition.dx <= 0) {
        progress = 0.0;
      } else {
        progress = event.localPosition.dx / width;
      }
      // 计算出当前时间
      setState(() {
        countTime = (progress * materia.duration).floor();

        // 指定播放位置
        _controller.seekTo(Duration(seconds: countTime));
      });
    }
  }

  String setCountTime(int time) {
    if (time < 60) {
      var second = time < 10 ? "0$time" : time;
      return "00:$second";
    } else {
      var minute = (time / 60).floor();
      var second = time % 60;

      var m = minute < 10 ? "0$minute" : minute;
      var s = second < 10 ? "0$second" : second;
      return "$m:$s";
    }
  }

  // 设置进度条是否显示
  setProgressShow() {
    _showTimerProgress?.cancel();
    setState(() {
      _isShowProgress = true;
    });

    _showTimerProgress = Timer.periodic(Duration(seconds: 3), (timer) {
      _showTimerProgress?.cancel();
      setState(() {
        _isShowProgress = false;
      });
    });
  }
}

// 全屏视频
class FillScreenPlayer extends StatefulWidget {
  ///视频插件的构造方法
  final controller;

  ///播放进度
  final countTime;

  ///视频信息
  final materia;

  ///是否可以拖动进度条
  bool isSetProgress;

  FillScreenPlayer({
    Key key,
    @required this.controller,
    @required this.countTime,
    @required this.materia,
    this.isSetProgress = true,
  }) : super(key: key);

  @override
  _FillScreenPlayerState createState() => _FillScreenPlayerState();
}

class _FillScreenPlayerState extends State<FillScreenPlayer> with MyScreenUtil {
  GlobalKey _myKey = new GlobalKey();

  ///是否可以拖动进度条
  bool isSetProgress;

  VideoPlayerController controller;
  MateriaDataType materia;
  int countTime; //播放进度
  Timer _timer; //定时器

  Timer _showTimerProgress; //设置进度条消失时间
  bool _isShowProgress = false; //进度条是否显示

  @override
  void initState() {
    isSetProgress = widget.isSetProgress;

    controller = widget.controller;
    countTime = widget.countTime;
    materia = widget.materia;

    // 设置是否显示进度器
    setProgressShow();

    // 定时器
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final bool isPlaying = controller.value.isPlaying;
      setState(() {
        if (isPlaying) {
          countTime++;

          // 触发订阅事件
          eventBus.fire(CustomEvent(countTime));

          if (countTime >= materia.duration) {
            _timer.cancel();
          }
        }
      });
    });

    //强制切换屏幕方向
    OrientationPlugin.forceOrientation(
      DeviceOrientation.landscapeRight,
    );

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //强制切换屏幕方向
    OrientationPlugin.forceOrientation(
      DeviceOrientation.portraitUp,
    );

    _timer.cancel();
    _showTimerProgress.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: InkWell(
              onTap: () {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();

                setProgressShow();
              },
              child: VideoPlayer(controller),
            ),
          ),
          // 时间与进度条
          _isShowProgress
              ? Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: dp(15.0),
                      bottom: dp(15.0),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: dp(26.0),
                                ),
                                text: "${setCountTime(countTime)} / ",
                                children: [
                                  TextSpan(
                                    text:
                                        "${(materia.duration / 60).toStringAsFixed(2)}",
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            key: _myKey,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              // 点击进度条
                              onPanDown: (DragDownDetails event) {
                                setProgressTime(event);
                              },
                              // 拖动进度条
                              onPanUpdate: (DragUpdateDetails event) {
                                setProgressTime(event);
                              },
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation(Colors.blue),
                                value: countTime / materia.duration,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Icon(
                                aliIconfont.magnify,
                                color: Colors.white,
                                size: dp(36.0),
                              ),
                              onTap: () {
                                Navigator.pop(context, countTime);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  String setCountTime(int time) {
    if (time < 60) {
      var second = time < 10 ? "0$time" : time;
      return "00:$second";
    } else {
      var minute = (time / 60).floor();
      var second = time % 60;

      var m = minute < 10 ? "0$minute" : minute;
      var s = second < 10 ? "0$second" : second;
      return "$m:$s";
    }
  }

  // 设置播放进度
  void setProgressTime(event) {
    if (isSetProgress) {
      setProgressShow();
      // 当前组件的宽度
      double width = _myKey.currentContext.size.width;
      // 计算出当前进度
      double progress = 0;
      if (event.localPosition.dx >= width) {
        progress = 1.0;
      } else if (event.localPosition.dx <= 0) {
        progress = 0.0;
      } else {
        progress = event.localPosition.dx / width;
      }
      // 计算出当前时间
      setState(() {
        countTime = (progress * materia.duration).floor();

        // 指定播放位置
        controller.seekTo(Duration(seconds: countTime));

        // 触发订阅事件
        eventBus.fire(CustomEvent(countTime));
      });
    }
  }

  // 设置进度条是否显示
  setProgressShow() {
    _showTimerProgress?.cancel();
    setState(() {
      _isShowProgress = true;
    });

    _showTimerProgress = Timer.periodic(Duration(seconds: 3), (timer) {
      _showTimerProgress?.cancel();
      setState(() {
        _isShowProgress = false;
      });
    });
  }
}
