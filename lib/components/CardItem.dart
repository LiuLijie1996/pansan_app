import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import './MyIcon.dart';
import '../mixins/mixins.dart';
import '../models/NewsDataType.dart';
import '../models/CourseDataType.dart';
import '../utils/myRequest.dart';

// 新闻卡片
class NewsCardItem extends StatelessWidget with MyScreenUtil {
  final NewsDataType item;
  final Function onClick;

  const NewsCardItem({
    Key key,
    @required this.onClick,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 学习状态
    String statusText;
    // 学习状态背景
    Color statusColor;

    // 添加时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      item.addtime * 1000,
    );
    String _addtime = formatDate(
      addtime,
      [yyyy, '-', mm, '-', dd],
    );

    if (item.imgList != null && item.imgList.length > 1) {
      ///图片列表
      List imgList = [];

      for (var i = 0; i < item.imgList.length; i++) {
        if (i < 3) {
          imgList.add(item.imgList[i]);
        }
      }

      // 多图新闻
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/newsDetail", arguments: item);
        },
        child: Container(
          padding: EdgeInsets.only(
            top: dp(20.0),
            bottom: dp(20.0),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Colors.grey[100],
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Container(
                padding: EdgeInsets.only(
                  left: dp(20.0),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: dp(32.0),
                      color: Colors.black,
                      height: 1.5,
                    ),
                    children: <InlineSpan>[
                      TextSpan(text: '${item.title}'),
                    ],
                  ),
                ),
              ),

              // 封面
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: dp(20.0), right: dp(20.0), top: dp(20.0)),
                child: Row(
                  children: imgList.map((e) {
                    int index = imgList.indexOf(e);
                    double left = index != 0 ? dp(2.0) : 0.0;
                    return Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: left,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(dp(10.0)),
                            child: Image.network(
                              e,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // 日期
              Container(
                padding: EdgeInsets.only(
                  left: dp(20.0),
                  top: dp(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          myIcon['time'],
                          size: dp(24.0),
                          color: Colors.grey,
                        ),
                        SizedBox(width: dp(10.0)),
                        Text(
                          "$_addtime", //时间
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: dp(20.0)),
                    Row(
                      children: [
                        Icon(
                          aliIconfont.zan,
                          size: dp(36.0),
                          color: Colors.grey,
                        ),
                        SizedBox(width: dp(10.0)),
                        Text(
                          "${item.upvote}", //点赞人数
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 单图新闻
    return GestureDetector(
      onTap: () {
        // onClick();

        Navigator.pushNamed(context, "/newsDetail", arguments: item);
      },
      child: AspectRatio(
        aspectRatio: item.thumbUrl != '' ? 16 / 5 : 16 / 4.1,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Colors.grey[100],
              ),
            ),
          ),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(dp(20.0)),
            child: Row(
              children: [
                item.thumbUrl != ''
                    ? Container(
                        child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(dp(10.0)),
                            child: Image.network(
                              "${item.thumbUrl}", //封面地址
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Text(''),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: dp(item.thumbUrl == '' ? 0.0 : 20.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${item.title}", //标题
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: dp(32.0),
                            ),
                          ),
                        ),

                        // 日期
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      myIcon['time'],
                                      size: dp(24.0),
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: dp(10.0)),
                                    Text(
                                      "$_addtime", //时间
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      aliIconfont.zan,
                                      size: dp(36.0),
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: dp(10.0)),
                                    Text(
                                      "${item.upvote}", //点赞人数
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 课程卡片
class CourseCardItem extends StatelessWidget with MyScreenUtil {
  final CourseDataType item;
  final Function onClick;

  const CourseCardItem({
    Key key,
    @required this.onClick,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 学习状态
    String statusText;
    // 学习状态背景
    Color statusColor;

    statusText = item.studyStatus == 1
        ? '已学完'
        : item.studyStatus == 2
            ? '未学习'
            : '学习中';

    statusColor = item.studyStatus == 1
        ? Colors.blue
        : item.studyStatus == 2
            ? Colors.grey
            : Colors.green;

    // 添加时间
    DateTime addtime = DateTime.fromMillisecondsSinceEpoch(
      item.addtime * 1000,
    );
    String _addtime = formatDate(
      addtime,
      [yyyy, '-', mm, '-', dd],
    );

    // GestureDetector
    return GestureDetector(
      onTap: () {
        // 跳转到课程详情页
        Navigator.pushNamed(context, "/courseDetail", arguments: item);
      },
      child: AspectRatio(
        aspectRatio: item.thumbUrl != '' ? 16 / 5 : 16 / 4.1,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Colors.grey[100],
              ),
            ),
          ),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(dp(20.0)),
            child: Row(
              children: [
                item.thumbUrl != ''
                    ? Container(
                        child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(dp(10.0)),
                            child: Image.network(
                              "${item.thumbUrl}", //封面地址
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Text(''),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: dp(20.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${item.name}", //标题
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: dp(32.0),
                            ),
                          ),
                        ),

                        // 学习状态
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: statusText != null
                                ? Container(
                                    padding: EdgeInsets.only(
                                      left: dp(20.0),
                                      right: dp(20.0),
                                      top: dp(4.0),
                                      bottom: dp(4.0),
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(dp(20.0)),
                                      ),
                                    ),
                                    child: Text(
                                      "$statusText",
                                      style: TextStyle(
                                        fontSize: dp(20.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),

                        // 日期
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      aliIconfont.time,
                                      size: dp(24.0),
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: dp(10.0)),
                                    Text(
                                      "$_addtime", //时间
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      aliIconfont.view,
                                      size: dp(36.0),
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: dp(10.0)),
                                    Text(
                                      "${item.viewNum}", //观看人数
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
