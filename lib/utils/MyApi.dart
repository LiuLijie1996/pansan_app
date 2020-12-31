import '../db/UserDB.dart';
import '../models/UserInfoDataType.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 接口
class MyApi {
  // 用户信息
  static Future<UserInfoDataType> get userInfo async {
    // 获取用户信息
    List<UserInfoDataType> userInfoList = await UserDB.findAll();
    UserInfoDataType info;
    if (userInfoList.length != 0) {
      info = userInfoList[0];
    }
    return info;
  }

  // 用户token
  static Future<String> get userToken async {
    UserInfoDataType info = await userInfo;
    String token;

    if (info != null) {
      token = info.token;
    }

    return token;
  }

  // 用户id
  static Future<int> get userId async {
    UserInfoDataType info = await userInfo;
    int id;

    if (info != null) {
      id = info.id;
    }

    return id;
  }

  // 设置传给后台的数据
  static Map<String, dynamic> newQuery({Map<String, dynamic> query}) {
    // token：pansan
    // t：时间戳
    // nonce（随机6位字符串）：ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678
    // sign（大写md5）： t + nonce + token

    // 秘钥
    var token = "pansan";
    var str = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678";
    var maxLen = str.length;
    // 设置的随机字符串
    var nonce = '';
    for (var i = 0; i < 6; i++) {
      var random = math.Random();
      int index = random.nextInt(maxLen - 1);
      nonce += str.substring(index, index + 1);
    }

    // 时间戳
    var t = new DateTime.now().millisecondsSinceEpoch;
    var encode = utf8.encode("$t$nonce$token");
    var sign = md5.convert(encode).toString().toUpperCase();

    Map<String, dynamic> data = {
      "nonce": nonce,
      "t": t,
      "sign": sign,
    };

    if (query != null) {
      data = {
        ...query,
        "nonce": nonce,
        "t": t,
        "sign": sign,
      };
    }

    return data;
  }

  /// 最新课程、联想词
  static const courseList = "/api/course/courseList";

  /// 课程分类导航
  static const getCourseItemList = "/api/course/getCourseItemList";

  /// 课程详情
  static const courseDetail = "/api/course/courseDetail";

  /// 发送课程阅读进度给后端
  static const courseProgress = "/api/course/courseProgress";

  /// 最新考试
  static const newKaoshi = "/api/exam/newKaoshi";

  /// 我要考试分类
  static const getTestItemList = "/api/exam/getTestItemList";

  /// 我要练习分类
  static const getPracticeItemList = "/api/exam/getPracticeItemList";

  /// 考试考题
  static const kaoTi = "/api/exam/kaoTi";

  /// 考试列表
  static const getTestList = "/api/exam/getTestList";

  /// 获取考试时间线
  static const examTimeLine = "/api/user/getTestList";

  /// 考试结束提交试卷
  static const saveUserTest = "/api/exam/saveUserTest";

  /// 获取专项练习列表
  static const getAllQuestionItemList = "/api/exam/exerciseSpecialtySelect";

  /// 获取专项练习列表中的题目
  static const getQuestionList = "/api/exam/getQuestionList";

  /// 练习列表
  static const getPracticeList = "/api/exercise/getPracticeList";

  /// 练习详情
  static const getOnePractice = "/api/exercise/getOnePractice";

  /// 普通练习提交数据
  static const saveUserPractice = "/api/exercise/saveUserPractice";

  /// 轮播图
  static const indexBanner = "/api/index/banner";

  /// 推荐新闻
  static const getIndexNewsList = "/api/news/getIndexNewsList";

  /// 新闻导航
  static const getNewsItemList = "/api/news/getNewsItemList";

  /// 通过导航获取新闻
  static const newsList = "/api/news/newsList";

  /// 新闻详情
  static const getNewsOne = "/api/news/getNewsOne";

  /// 新闻阅读完成
  static const newsUserScore = "/api/news/newsUserScore";

  /// 新闻点赞
  static const saveUserUpvote = "/api/news/saveUserUpvote";

  /// 积分明细
  static const getUserScoreList = "/api/score/getUserScoreList";

  /// 积分规则
  static const getScoreRule = "/api/score/getScoreRule";

  /// 积分商品
  static const goodsList = "/api/score/goodsList";

  /// 兑换记录
  static const getUserScoreExchange = "/api/score/getUserScoreExchange";

  /// 兑换商品
  static const userExchangeScore = "/api/score/userExchangeScore";

  /// 关键词
  static const getCourseTags = "/api/search/antistop";

  /// 用户一日一题列表
  static const getTodayUserStudy = "/api/user/getTodayUserStudy";

  /// 职工服务
  static const getUserServiceList = "/api/user/getUserServiceList";

  /// 添加咨询
  static const addUserService = "/api/user/addUserService";

  /// 获取咨询详情
  static const getUserServiceReply = "/api/user/getUserServiceReply";

  /// 获取我的班级
  static const getUserClass = "/api/user/getUserClass";

  /// 获取考勤记录
  static const getAttendDetail = "/api/user/getAttendDetail";

  /// 获取课程计划
  static const getTimeTableList = "/api/user/getTimeTableList";

  /// 获取考试排行
  static const testRankList = "/api/user/testRankList";

  /// 通知公告
  static const getUserMessage = "/api/user/getUserMessage";

  /// 登录
  static const login = "/api/login/login";

  /// 收藏的新闻
  static const getNewsCollect = "/api/news/getNewsCollect";

  /// 我的课程
  static const getUserCourseList = "/api/user/getUserCourseList";

  /// 上传
  static const upload = "/api/upload";

  /// 我的错题
  static const getUserErrQuestion = "/api/user/getUserErrQuestion";

  /// 获取收藏的试题
  static const getQuestionCollect = "/api/user/getQuestionCollect";

  /// 考试记录
  static const getUserTestRecordList = "/api/user/getUserTestRecordList";

  /// 考试记录对应的考题
  static const getUserTestAnswerList = "/api/user/getUserTestAnswerList";

  /// 一日一题详情
  static const getOneTodayStudy = "/api/user/getOneTodayStudy";

  /// 一日一题阅读完成
  static const saveTodayStudy = "/api/user/saveTodayStudy";

  /// 获取证书详情
  static const getUserCert = "/api/user/getUserCert";

  /// 发送已读通知公告
  static const saveUserMessage = "/api/user/saveUserMessage";

  /// 公告详情
  static const getOneMessage = "/api/user/getOneMessage";

  /// 应用报错时发送数据给后台
  static const error = "/api/error";
}