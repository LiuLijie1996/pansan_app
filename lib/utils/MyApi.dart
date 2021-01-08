/// 接口
class MyApi {
  /// 最新课程、联想词；测试接口：
  static const courseList = {
    "method": "post",
    "normal": "/course/courseList",
    "test": "/api/course/courseList",
  };

  /// 课程分类导航；测试接口：
  static const getCourseItemList = {
    "method": "get",
    "normal": "/course/getCourseItemList",
    "test": "/api/course/getCourseItemList",
  };

  /// 课程详情；测试接口：
  static const courseDetail = {
    "method": "post",
    "normal": "/course/courseDetail",
    "test": "/api/course/courseDetail",
  };

  /// 发送课程阅读进度给后端；测试接口：
  static const courseProgress = {
    "method": "post",
    "normal": "/course/courseProgress",
    "test": "/api/course/courseProgress",
  };

  /// 最新考试；测试接口：
  static const newKaoshi = {
    "method": "post",
    "normal": "/test/newKaoshi",
    "test": "/api/exam/newKaoshi",
  };

  /// 我要考试分类；测试接口：
  static const getTestItemList = {
    "method": "get",
    "normal": "/test/getTestItemList",
    "test": "/api/exam/getTestItemList",
  };

  /// 我要练习分类；测试接口：
  static const getPracticeItemList = {
    "method": "get",
    "normal": "/Practice/getPracticeItemList",
    "test": "/api/exam/getPracticeItemList",
  };

  /// 考试考题；测试接口：
  static const kaoTi = {
    "method": "post",
    "normal": "/appApi/test/kaoTi",
    "test": "/api/exam/kaoTi",
  };

  /// 考试列表；测试接口：
  static const getTestList = {
    "method": "post",
    "normal": "/test/getTestList",
    "test": "/api/exam/getTestList",
  };

  /// 获取考试时间线；测试接口：
  static const examTimeLine = {
    "method": "post",
    "normal": "/user/getTestList",
    "test": "/api/user/getTestList",
  };

  /// 考试结束提交试卷；测试接口：
  static const saveUserTest = {
    "method": "post",
    "normal": "/test/saveUserTest",
    "test": "/api/exam/saveUserTest",
  };

  /// 获取专项练习列表；测试接口：
  static const getAllQuestionItemList = {
    "method": "post",
    "normal": "/Practice/getAllQuestionItemList",
    "test": "/api/exam/exerciseSpecialtySelect",
  };

  /// 获取专项练习列表中的题目；测试接口：
  static const getQuestionList = {
    "method": "post",
    "normal": "/Practice/getQuestionList",
    "test": "/api/exam/getQuestionList",
  };

  /// 练习列表；测试接口：
  static const getPracticeList = {
    "method": "post",
    "normal": "/Practice/getPracticeList",
    "test": "/api/exercise/getPracticeList",
  };

  /// 练习详情；测试接口：
  static const getOnePractice = {
    "method": "post",
    "normal": "/Practice/getOnePractice",
    "test": "/api/exercise/getOnePractice",
  };

  /// 普通练习提交数据；测试接口：
  static const saveUserPractice = {
    "method": "post",
    "normal": "/Practice/saveUserPractice",
    "test": "/api/exercise/saveUserPractice",
  };

  /// 轮播图；测试接口：
  static const indexBanner = {
    "method": "post",
    "normal": "/index/indexBanner",
    "test": "/api/index/banner",
  };

  /// 推荐新闻；测试接口：
  static const getIndexNewsList = {
    "method": "post",
    "normal": "/news/getIndexNewsList",
    "test": "/api/news/getIndexNewsList",
  };

  /// 新闻导航；测试接口：
  static const getNewsItemList = {
    "method": "get",
    "normal": "/news/getNewsItemList",
    "test": "/api/news/getNewsItemList",
  };

  /// 通过导航获取新闻；测试接口：
  static const newsList = {
    "method": "post",
    "normal": "/news/newsList",
    "test": "/api/news/newsList",
  };

  /// 新闻详情；测试接口：
  static const getNewsOne = {
    "method": "post",
    "normal": "/news/getNewsOne",
    "test": "/api/news/getNewsOne",
  };

  /// 新闻阅读完成；测试接口：
  static const newsUserScore = {
    "method": "post",
    "normal": "/news/newsUserScore",
    "test": "/api/news/newsUserScore",
  };

  /// 新闻点赞；测试接口：
  static const saveUserUpvote = {
    "method": "post",
    "normal": "/news/saveUserUpvote",
    "test": "/api/news/saveUserUpvote",
  };

  /// 积分明细；测试接口：
  static const getUserScoreList = {
    "method": "post",
    "normal": "/user/getUserScoreList",
    "test": "/api/score/getUserScoreList",
  };

  /// 积分规则；测试接口：
  static const getScoreRule = {
    "method": "post",
    "normal": "/score/getScoreRule",
    "test": "/api/score/getScoreRule",
  };

  /// 积分商品；测试接口：
  static const goodsList = {
    "method": "post",
    "normal": "/score/goodsList",
    "test": "/api/score/goodsList",
  };

  /// 兑换记录；测试接口：
  static const getUserScoreExchange = {
    "method": "post",
    "normal": "/user/getUserScoreExchange",
    "test": "/api/score/getUserScoreExchange",
  };

  /// 兑换商品；测试接口：
  static const userExchangeScore = {
    "method": "post",
    "normal": "/score/userExchangeScore",
    "test": "/api/score/userExchangeScore",
  };

  /// 关键词；测试接口：
  static const getCourseTags = {
    "method": "get",
    "normal": "/course/getCourseTags",
    "test": "/api/search/antistop",
  };

  /// 用户一日一题列表；测试接口：
  static const getTodayUserStudy = {
    "method": "post",
    "normal": "/user/getTodayUserStudy",
    "test": "/api/user/getTodayUserStudy",
  };

  /// 职工服务；测试接口：
  static const getUserServiceList = {
    "method": "post",
    "normal": "/user/getUserServiceList",
    "test": "/api/user/getUserServiceList",
  };

  /// 添加咨询；测试接口：
  static const addUserService = {
    "method": "post",
    "normal": "/user/addUserService",
    "test": "/api/user/addUserService",
  };

  /// 获取咨询详情；测试接口：
  static const getUserServiceReply = {
    "method": "post",
    "normal": "/user/getUserServiceReply",
    "test": "/api/user/getUserServiceReply",
  };

  /// 获取我的班级；测试接口：
  static const getUserClass = {
    "method": "post",
    "normal": "/user/getUserClass",
    "test": "/api/user/getUserClass",
  };

  /// 获取考勤记录；测试接口：
  static const getAttendDetail = {
    "method": "post",
    "normal": "/user/getAttendDetail",
    "test": "/api/user/getAttendDetail",
  };

  /// 获取课程计划；测试接口：
  static const getTimeTableList = {
    "method": "post",
    "normal": "/user/getTimeTableList",
    "test": "/api/user/getTimeTableList",
  };

  /// 获取考试排行；测试接口：
  static const testRankList = {
    "method": "post",
    "normal": "/user/testRankList",
    "test": "/api/user/testRankList",
  };

  /// 通知公告；测试接口：
  static const getUserMessage = {
    "method": "post",
    "normal": "/user/getUserMessage",
    "test": "/api/user/getUserMessage",
  };

  /// 登录；测试接口：
  static const login = {
    "method": "post",
    "normal": "/login/login",
    "test": "/api/login/login",
  };

  /// 收藏的新闻；测试接口：
  static const getNewsCollect = {
    "method": "post",
    "normal": "/news/getNewsCollect",
    "test": "/api/news/getNewsCollect",
  };

  /// 我的课程；测试接口：
  static const getUserCourseList = {
    "method": "post",
    "normal": "/user/getUserCourseList",
    "test": "/api/user/getUserCourseList",
  };

  /// 上传图片
  static const upload = {
    "method": "upload",
    "normal": "/upload/uploadImg",
    "test": "/upload/uploadImg",
  };

  /// 我的错题；测试接口：
  static const getUserErrQuestion = {
    "method": "post",
    "normal": "/user/getUserErrQuestion",
    "test": "/api/user/getUserErrQuestion",
  };

  /// 获取收藏的试题；测试接口：
  static const getQuestionCollect = {
    "method": "post",
    "normal": "/user/getQuestionCollect",
    "test": "/api/user/getQuestionCollect",
  };

  /// 考试记录；测试接口：
  static const getUserTestRecordList = {
    "method": "post",
    "normal": "/user/getUserTestRecordList",
    "test": "/api/user/getUserTestRecordList",
  };

  /// 考试记录对应的考题；测试接口：
  static const getUserTestAnswerList = {
    "method": "post",
    "normal": "/user/getUserTestAnswerList",
    "test": "/api/user/getUserTestAnswerList",
  };

  /// 一日一题详情；测试接口：
  static const getOneTodayStudy = {
    "method": "post",
    "normal": "/user/getOneTodayStudy",
    "test": "/api/user/getOneTodayStudy",
  };

  /// 一日一题阅读完成；测试接口：
  static const saveTodayStudy = {
    "method": "post",
    "normal": "/user/saveTodayStudy",
    "test": "/api/user/saveTodayStudy",
  };

  /// 获取证书详情；测试接口：
  static const getUserCert = {
    "method": "post",
    "normal": "/user/getUserCert",
    "test": "/api/user/getUserCert",
  };

  /// 发送已读通知公告；测试接口：
  static const saveUserMessage = {
    "method": "post",
    "normal": "/user/saveUserMessage",
    "test": "/api/user/saveUserMessage",
  };

  /// 公告详情；测试接口：
  static const getOneMessage = {
    "method": "post",
    "normal": "/user/getOneMessage",
    "test": "/api/user/getOneMessage",
  };

  /// 应用报错时发送数据给后台；测试接口：
  static const error = {
    "method": "post",
    "normal": "/base/saveErrorLog",
    "test": "/api/error",
  };

  /// 修改用户信息
  static const editUser = {
    "method": "post",
    "normal": "/user/editUser",
    "test": "/user/editUser",
  };

  /// 修改用户信息；测试接口：
  static const saveeErrorCorrection = {
    "method": "post",
    "normal": "/user/saveeErrorCorrection",
    "test": "/api/exam/saveeErrorCorrection",
  };

  /// 完成情况；测试接口：
  static const courseSituation = {
    "method": "post",
    "normal": "/course/courseSituation",
    "test": "/api/course/courseSituation",
  };

  /// 收藏题目；测试接口：
  static const addQuestionCollect = {
    "method": "post",
    "normal": "/user/addQuestionCollect",
    "test": "/api/exam/addQuestionCollect",
  };

  /// 收藏新闻；测试接口：
  static const addNewsCollect = {
    "method": "post",
    "normal": "/news/addNewsCollect",
    "test": "/api/news/addNewsCollect",
  };

  /// 扫码加入班级；测试接口：
  static const userAddClass = {
    "method": "post",
    "normal": "/user/userAddClass",
    "test": "/api/user/userAddClass",
  };

  /// 真正的加入班级请求；测试接口：
  static const addClass = {
    "method": "post",
    "normal": "/user/userAddClass",
    "test": "/api/user/addClass",
  };

  /// 签到；测试接口：
  static const signClass = {
    "method": "post",
    "normal": "/user/signClass",
    "test": "/api/user/signClass",
  };

  /// 获取用户总积分；测试接口：
  static const getuserScoreTotal = {
    "method": "post",
    "normal": "/user/getuserScoreTotal",
    "test": "/api/user/getuserScoreTotal",
  };

  /// 修改密码；测试接口：
  static const editPassWord = {
    "method": "post",
    "normal": "/user/editPassWord",
    "test": "/api/user/editPassWord",
  };

  /// 检查更新；测试接口：
  static const version = {
    "method": "post",
    "normal": "/login/version",
    "test": "/api/index/version",
  };

  /// 获取验证码
  static const loginCode = {
    "method": "post",
    "normal": "/login/code",
    "test": "/login/code",
  };

  /// 注册
  static const register = {
    "method": "post",
    "normal": "/login/register",
    "test": "/login/register",
  };

  /// 忘记密码
  static const resetPassWord = {
    "method": "post",
    "normal": "/login/resetPassWord",
    "test": "/login/resetPassWord",
  };

  /// 下载文件
  static const downloadFile = {
    "method": "download",
    "normal": null,
    "test": null,
  };
}
