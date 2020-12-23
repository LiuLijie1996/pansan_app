import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/MateriaDataType.dart';
import '../mixins/withScreenUtil.dart';

class MyAudioplayers extends StatefulWidget {
  MateriaDataType materia;
  MyAudioplayers({Key key, @required this.materia}) : super(key: key);

  @override
  MyAudioplayersState createState() => MyAudioplayersState();
}

class MyAudioplayersState extends State<MyAudioplayers> with MyScreenUtil {
  AudioPlayer audioPlayer;
  MateriaDataType materia;
  bool is_play = true; //是否播放
  ///播放进度时间
  int countTime = 0;
  GlobalKey _myKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    materia = widget.materia;

    audioPlayer = AudioPlayer();
    // 音频监听器
    audioPlayer.onAudioPositionChanged.listen((p) async {
      setState(() {
        countTime = p.inSeconds;

        if (countTime >= materia.duration) {
          is_play = false;
        }
      });
    });
    // 播放
    play();
  }

  @override
  void deactivate() async {
    print('结束');
    int result = await audioPlayer.release();
    if (result == 1) {
      print('release success');
    } else {
      print('release failed');
    }
    super.deactivate();
  }

  // @override
  // void dispose() async {
  //   // 释放资源
  //   await audioPlayer?.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: dp(20.0),
        bottom: dp(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                is_play ? pause() : play();
                setState(() {
                  is_play = !is_play;
                });
              },
              // child: Text(is_play ? "暂停" : "播放"),
              child: Icon(is_play ? Icons.pause : Icons.play_arrow),
            ),
          ),

          // 进度
          Expanded(
            flex: 5,
            child: Container(
              key: _myKey,
              width: double.infinity,
              alignment: Alignment.center,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                value: countTime / materia.duration,
              ),
            ),
          ),

          // 时间
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text("${setCountTime(countTime)}"),
            ),
          ),
        ],
      ),
    );
  }

  // 播放
  play() async {
    print(materia.link);
    print(materia.duration);
    int result = await audioPlayer.play(materia.link);
    if (result == 1) {
      // success
      print('play success');
    } else {
      print('play failed');
    }
  }

  // 暂停
  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      // success
      print('pause success');
    } else {
      print('pause failed');
    }
  }

  // 格式化进度时间
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
}
