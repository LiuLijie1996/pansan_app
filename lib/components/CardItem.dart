import 'package:flutter/material.dart';
import 'MyIcon.dart';

// 新闻卡片、课程卡片
class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
    @required this.onClick,
    @required this.item,
  }) : super(key: key);

  final item;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    // 学习状态
    String statusText;
    // 学习状态背景
    Color statusColor;

    if (item['status'] != null) {
      print(item['status']);
      statusText = item['status'] == 1
          ? '已学完'
          : item['status'] == 2
              ? '未学习'
              : '学习中';

      statusColor = item['status'] == 1
          ? Colors.blue
          : item['status'] == 2
              ? Colors.grey
              : Colors.green;
    }

    // GestureDetector
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: AspectRatio(
        aspectRatio: item['thumb_url'] != '' ? 16 / 5 : 16 / 4.1,
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
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                item['thumb_url'] != ''
                    ? Container(
                        child: AspectRatio(
                          aspectRatio: 16 / 9.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              "${item['thumb_url']}", //封面地址
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Text(''),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${item['title']}", //标题
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
                                      left: 10.0,
                                      right: 10.0,
                                      top: 2.0,
                                      bottom: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Text(
                                      "$statusText",
                                      style: TextStyle(
                                        fontSize: 10.0,
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
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${item['addtime']}", //时间
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
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${item['view_num']}", //观看人数
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
