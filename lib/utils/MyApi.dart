/// 接口
class MyApi {
  /// 最新课程、联想词；测试接口：/api/course/courseList
  static const courseList = {
    "path": "/course/courseList",
    "method": "post",
  };

  /// 课程分类导航；测试接口：/api/course/getCourseItemList
  static const getCourseItemList = {
    "path": "/course/getCourseItemList",
    "method": "get",
  };

  /// 课程详情；测试接口：/api/course/courseDetail
  static const courseDetail = {
    "path": "/course/courseDetail",
    "method": "post",
  };

  /// 发送课程阅读进度给后端；测试接口：/api/course/courseProgress
  static const courseProgress = {
    "path": "/course/courseProgress",
    "method": "post",
  };

  /// 最新考试；测试接口：/api/exam/newKaoshi
  static const newKaoshi = {
    "path": "/test/newKaoshi",
    "method": "post",
  };

  /// 我要考试分类；测试接口：/api/exam/getTestItemList
  static const getTestItemList = {
    "path": "/test/getTestItemList",
    "method": "get",
  };

  /// 我要练习分类；测试接口：/api/exam/getPracticeItemList
  static const getPracticeItemList = {
    "path": "/Practice/getPracticeItemList",
    "method": "get",
  };

  /// 考试考题；测试接口：/api/exam/kaoTi
  static const kaoTi = {
    "path": "/appApi/test/kaoTi",
    "method": "post",
  };

  /// 考试列表；测试接口：/api/exam/getTestList
  static const getTestList = {
    "path": "/test/getTestList",
    "method": "post",
  };

  /// 获取考试时间线；测试接口：/api/user/getTestList
  static const examTimeLine = {
    "path": "/user/getTestList",
    "method": "post",
  };

  /// 考试结束提交试卷；测试接口：/api/exam/saveUserTest
  static const saveUserTest = {
    "path": "/test/saveUserTest",
    "method": "post",
  };

  /// 获取专项练习列表；测试接口：/api/exam/exerciseSpecialtySelect
  static const getAllQuestionItemList = {
    "path": "/Practice/getAllQuestionItemList",
    "method": "post"
  };

  /// 获取专项练习列表中的题目；测试接口：/api/exam/getQuestionList
  static const getQuestionList = {
    "path": "/Practice/getQuestionList",
    "method": "post"
  };

  /// 练习列表；测试接口：/api/exercise/getPracticeList
  static const getPracticeList = {
    "path": "/Practice/getPracticeList",
    "method": "post"
  };

  /// 练习详情；测试接口：/api/exercise/getOnePractice
  static const getOnePractice = {
    "path": "/Practice/getOnePractice",
    "method": "post"
  };

  /// 普通练习提交数据；测试接口：/api/exercise/saveUserPractice
  static const saveUserPractice = {
    "path": "/Practice/saveUserPractice",
    "method": "post",
  };

  /// 轮播图；测试接口：/api/index/banner
  static const indexBanner = {
    "path": "/index/indexBanner",
    "method": "post",
  };

  /// 推荐新闻；测试接口：/api/news/getIndexNewsList
  static const getIndexNewsList = {
    "path": "/news/getIndexNewsList",
    "method": "post",
  };

  /// 新闻导航；测试接口：/api/news/getNewsItemList
  static const getNewsItemList = {
    "path": "/news/getNewsItemList",
    "method": "get",
  };

  /// 通过导航获取新闻；测试接口：/api/news/newsList
  static const newsList = {
    "path": "/news/newsList",
    "method": "post",
  };

  /// 新闻详情；测试接口：/api/news/getNewsOne
  static const getNewsOne = {
    "path": "/news/getNewsOne",
    "method": "post",
  };

  /// 新闻阅读完成；测试接口：/api/news/newsUserScore
  static const newsUserScore = {
    "path": "/news/newsUserScore",
    "method": "post",
  };

  /// 新闻点赞；测试接口：/api/news/saveUserUpvote
  static const saveUserUpvote = {
    "path": "/news/saveUserUpvote",
    "method": "post",
  };

  /// 积分明细；测试接口：/api/score/getUserScoreList
  static const getUserScoreList = {
    "path": "/user/getUserScoreList",
    "method": "post",
  };

  /// 积分规则；测试接口：/api/score/getScoreRule
  static const getScoreRule = {
    "path": "/score/getScoreRule",
    "method": "post",
  };

  /// 积分商品；测试接口：/api/score/goodsList
  static const goodsList = {
    "path": "/score/goodsList",
    "method": "post",
  };

  /// 兑换记录；测试接口：/api/score/getUserScoreExchange
  static const getUserScoreExchange = {
    "path": "/user/getUserScoreExchange",
    "method": "post",
  };

  /// 兑换商品；测试接口：/api/score/userExchangeScore
  static const userExchangeScore = {
    "path": "/score/userExchangeScore",
    "method": "post",
  };

  /// 关键词；测试接口：/api/search/antistop
  static const getCourseTags = {
    "path": "/course/getCourseTags",
    "method": "get",
  };

  /// 用户一日一题列表；测试接口：/api/user/getTodayUserStudy
  static const getTodayUserStudy = {
    "path": "/user/getTodayUserStudy",
    "method": "post",
  };

  /// 职工服务；测试接口：/api/user/getUserServiceList
  static const getUserServiceList = {
    "path": "/user/getUserServiceList",
    "method": "post",
  };

  /// 添加咨询；测试接口：/api/user/addUserService
  static const addUserService = {
    "path": "/user/addUserService",
    "method": "post",
  };

  /// 获取咨询详情；测试接口：/api/user/getUserServiceReply
  static const getUserServiceReply = {
    "path": "/user/getUserServiceReply",
    "method": "post",
  };

  /// 获取我的班级；测试接口：/api/user/getUserClass
  static const getUserClass = {
    "path": "/user/getUserClass",
    "method": "post",
  };

  /// 获取考勤记录；测试接口：/api/user/getAttendDetail
  static const getAttendDetail = {
    "path": "/user/getAttendDetail",
    "method": "post",
  };

  /// 获取课程计划；测试接口：/api/user/getTimeTableList
  static const getTimeTableList = {
    "path": "/user/getTimeTableList",
    "method": "post",
  };

  /// 获取考试排行；测试接口：/api/user/testRankList
  static const testRankList = {
    "path": "/user/testRankList",
    "method": "post",
  };

  /// 通知公告；测试接口：/api/user/getUserMessage
  static const getUserMessage = {
    "path": "/user/getUserMessage",
    "method": "post",
  };

  /// 登录；测试接口：/api/login/login
  static const login = {
    "path": "/login/login",
    "method": "post",
  };

  /// 收藏的新闻；测试接口：/api/news/getNewsCollect
  static const getNewsCollect = {
    "path": "/news/getNewsCollect",
    "method": "post",
  };

  /// 我的课程；测试接口：/api/user/getUserCourseList
  static const getUserCourseList = {
    "path": "/user/getUserCourseList",
    "method": "post",
  };

  /// 上传图片
  static const upload = {
    "path": "/upload/uploadImg",
    "method": "upload",
  };

  /// 我的错题；测试接口：/api/user/getUserErrQuestion
  static const getUserErrQuestion = {
    "path": "/user/getUserErrQuestion",
    "method": "post",
  };

  /// 获取收藏的试题；测试接口：/api/user/getQuestionCollect
  static const getQuestionCollect = {
    "path": "/user/getQuestionCollect",
    "method": "post",
  };

  /// 考试记录；测试接口：/api/user/getUserTestRecordList
  static const getUserTestRecordList = {
    "path": "/user/getUserTestRecordList",
    "method": "post",
  };

  /// 考试记录对应的考题；测试接口：/api/user/getUserTestAnswerList
  static const getUserTestAnswerList = {
    "path": "/user/getUserTestAnswerList",
    "method": "post",
  };

  /// 一日一题详情；测试接口：/api/user/getOneTodayStudy
  static const getOneTodayStudy = {
    "path": "/user/getOneTodayStudy",
    "method": "post",
  };

  /// 一日一题阅读完成；测试接口：/api/user/saveTodayStudy
  static const saveTodayStudy = {
    "path": "/user/saveTodayStudy",
    "method": "post",
  };

  /// 获取证书详情；测试接口：/api/user/getUserCert
  static const getUserCert = {
    "path": "/user/getUserCert",
    "method": "post",
  };

  /// 发送已读通知公告；测试接口：/api/user/saveUserMessage
  static const saveUserMessage = {
    "path": "/user/saveUserMessage",
    "method": "post",
  };

  /// 公告详情；测试接口：/api/user/getOneMessage
  static const getOneMessage = {
    "path": "/user/getOneMessage",
    "method": "post",
  };

  /// 应用报错时发送数据给后台；测试接口：/api/error
  static const error = {
    "path": "/base/saveErrorLog",
    "method": "post",
  };

  /// 修改用户信息
  static const editUser = {
    "path": "/user/editUser",
    "method": "post",
  };

  /// 修改用户信息；测试接口：/api/exam/saveeErrorCorrection
  static const saveeErrorCorrection = {
    "path": "/user/saveeErrorCorrection",
    "method": "post",
  };

  /// 完成情况；测试接口：/api/course/courseSituation
  static const courseSituation = {
    "path": "/course/courseSituation",
    "method": "post",
  };

  /// 收藏题目；测试接口：/api/exam/addQuestionCollect
  static const addQuestionCollect = {
    "path": "/user/addQuestionCollect",
    "method": "post",
  };

  /// 收藏新闻；测试接口：/api/news/addNewsCollect
  static const addNewsCollect = {
    "path": "/news/addNewsCollect",
    "method": "post",
  };

  /// 扫码加入班级；测试接口：/api/user/userAddClass
  static const userAddClass = {
    "path": "/user/userAddClass",
    "method": "post",
  };

  /// 真正的加入班级请求；测试接口：/api/user/addClass
  static const addClass = {
    "path": "/user/userAddClass",
    "method": "post",
  };

  /// 签到；测试接口：/api/user/signClass
  static const signClass = {
    "path": "/user/signClass",
    "method": "post",
  };

  /// 获取用户总积分；测试接口：/api/user/getuserScoreTotal
  static const getuserScoreTotal = {
    "path": "/user/getuserScoreTotal",
    "method": "post",
  };

  /// 修改密码；测试接口：/api/user/editPassWord
  static const editPassWord = {
    "path": "/user/editPassWord",
    "method": "post",
  };

  /// 检查更新；测试接口：/api/index/version
  static const version = {
    "path": "/login/version",
    "method": "post",
  };

  /// 获取验证码
  static const loginCode = {
    "path": "/login/code",
    "method": "post",
  };

  /// 注册
  static const register = {
    "path": "/login/register",
    "method": "post",
  };

  /// 忘记密码
  static const resetPassWord = {
    "path": "/login/resetPassWord",
    "method": "post",
  };

  /// 下载文件
  static const downloadFile = {
    "path": null,
    "method": "download",
  };
}
