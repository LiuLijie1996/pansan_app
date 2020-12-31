import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:orientation/orientation.dart';
import 'package:event_bus/event_bus.dart';
import './MyIcon.dart';
import './MyProgress.dart';
import '../mixins/mixins.dart';
import '../models/MateriaDataType.dart';

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

  ///是否播放
  bool is_play;

  ///视频比例
  double aspectRatio;

  ///刷新父组件的回调
  Function setStateCallball;

  ///父级获取视频播放时间的回调
  Function(Duration) getPlayPosition;

  MyVideoPlayer({
    Key key,
    @required this.materia,
    this.countTime = 0,
    this.isSetProgress = true,
    this.aspectRatio,
    this.setStateCallball,
    this.is_play = false,
    this.getPlayPosition,
  }) : super(key: key);

  @override
  MyVideoPlayerState createState() => MyVideoPlayerState();
}

class MyVideoPlayerState extends State<MyVideoPlayer> with MyScreenUtil {
  ///视频比例
  double aspectRatio;

  GlobalKey _myKey = new GlobalKey();

  ///是否可以拖动进度条
  bool isSetProgress;

  MateriaDataType materia;

  ///视频控制器
  VideoPlayerController _controller;

  ///是否播放
  bool verticalPlaying = false;

  ///播放进度时间
  int countTime;

  Timer _showTimerProgress; //设置进度条消失时间
  bool _isShowProgress = false; //进度条是否显示

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.aspectRatio != null) {
      aspectRatio = widget.aspectRatio;
    }

    isSetProgress = widget.isSetProgress;

    materia = widget.materia; //视频信息
    countTime = widget.countTime; //播放进度

    _controller = VideoPlayerController.network(materia.link)
      // 播放状态
      ..addListener(() {
        if (widget.getPlayPosition != null) {
          // 触发父级获取视频播放时间的回调
          widget.getPlayPosition(_controller.value.position);
        }

        // 获取播放时间
        setState(() {
          countTime = _controller.value.position.inSeconds;
          // if (countTime >= materia.duration) {
          //   verticalPlaying = false;
          // }
        });

        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != verticalPlaying) {
          setState(() {
            verticalPlaying = isPlaying;
          });
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});

        print("初始化完成，判断是否播放");
        if (widget.is_play) {
          _controller.play();
        }

        print("上次学习时长：${materia.studyDuration}");

        // 指定播放位置
        _controller.seekTo(Duration(seconds: materia.studyDuration ?? 0));

        // 设置是否显示进度器
        setProgressShow();
      });
  }

  @override
  void dispose() {
    _showTimerProgress?.cancel(); //清除定时器
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
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio != null
                ? aspectRatio
                : _controller.value.aspectRatio,
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
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: dp(26.0),
                                ),
                                text: "${setCountTime(countTime)}",
                                // children: [
                                //   TextSpan(
                                //     text:
                                //         " / ${(materia.duration / 60).toStringAsFixed(2)}",
                                //   )
                                // ],
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
                                        isSetProgress: isSetProgress,
                                        countTime: countTime,
                                        controller: _controller,
                                        materia: materia,
                                      );
                                    },
                                  ),
                                );

                                // 刷新父组件
                                if (widget.setStateCallball != null) {
                                  widget.setStateCallball();
                                }
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

  // 手势事件
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

  // 设置当前进度时间
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

  // 暂停播放
  pause() {
    // 暂停播放
    _controller.pause();
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

  VideoPlayerController controller; //视频组件控制器
  MateriaDataType materia; //视频资源
  int countTime; //播放进度

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

    //强制切换屏幕方向
    OrientationPlugin.forceOrientation(
      DeviceOrientation.landscapeRight,
    );

    controller?.addListener(() {
      // 获取播放时间
      if (this.mounted) {
        setState(() {
          countTime = controller.value.position.inSeconds;
          if (countTime >= materia.duration) {
            _isShowProgress = false;
          }
        });

        final bool isPlaying = controller.value.isPlaying;
        if (isPlaying != _isShowProgress) {
          setState(() {
            _isShowProgress = isPlaying;
          });
        }
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //强制切换屏幕方向
    OrientationPlugin.forceOrientation(
      DeviceOrientation.portraitUp,
    );

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
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: dp(26.0),
                                ),
                                text: "${setCountTime(countTime)}",
                                // children: [
                                //   TextSpan(
                                //     text:
                                //         " / ${(materia.duration / 60).toStringAsFixed(2)}",
                                //   )
                                // ],
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

  // 设置进度时间
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

  // 设置进度条进度
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
