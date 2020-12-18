import 'package:flutter/material.dart';
import 'package:pansan_app/mixins/withScreenUtil.dart';
import 'MyIcon.dart';
import 'package:date_format/date_format.dart';
import 'package:pansan_app/models/NewsDataType.dart';
import 'package:pansan_app/models/CourseDataType.dart';

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

    // GestureDetector
    return GestureDetector(
      onTap: () {
        onClick();
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
                          aspectRatio: 16 / 9.5,
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
                            "${item.title}", //标题
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
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
                                      myIcon['time'],
                                      size: dp(24.0),
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
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
                                      myIcon['view'],
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
        onClick();
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
                          aspectRatio: 16 / 9.5,
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
                              fontSize: 16,
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
                                    SizedBox(width: 5),
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
