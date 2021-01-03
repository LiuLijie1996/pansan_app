## 页面名称

### tabbarPages

```
index.dart    首页
news.dart     新闻
study.dart    学习
exam.dart     考试
my.dart     我的
```

### pages

```
addAdvisory					添加咨询
dayTopic					一日一题
dayTopicDetail				一日一题详情
informAffiche				通知公告
afficheDetail				公告详情
login						登录、注册、忘记密码
searchCourseList			课程列表
settings					设置页面
staffServe					职工服务
certificateDetail			证书详情
testRecords					考试记录
updatePwd					修改密码
newsDetail					新闻详情
courseDetail				课程详情
finishSituation				完成情况
searchPage					搜索页

myAdvisory					我的咨询
advisoryDetail				咨询信息详情
myCollect					我的收藏
questionsCollect			试题收藏页面
myCourse					我的课程
myGrade						我的班级
examRanking					考试排行、选择考试
checkingInRecord			考勤记录
myInformation				个人信息
myMistakes					我的错题

integralCentre				积分中心
integralDetail				积分明细
exchangeRecord				兑换记录
integralRule				积分规则

examSiteInfo				考场信息

examSelect					考试列表选择
exerciseSelect				练习列表选择
exerciseSpecialtySelect		专项练习列表选择

examDetails					考试详情
exerciseDetails				练习详情
exerciseSpecialtyDetails	专项练习详情

examOver                 	考试结束页
exerciseOver             	练习结束页

examResultAnalyse			题目做完后的结果分析
questionsCorrection			试题纠错

answerSheet					答题卡
```



## 数据类型

```dart
///咨询类型
class AdvisoryDataType

///轮播图数据类型
class BannerDataType

///证书数据类型
class CertificateDataType
    
///证书详情数据类型
class CertificateDetailDataType
    
/// 课程章节数据类型
class CourseChapterDataType
    
/// 课程数据类型
class CourseDataType
    
///课程计划数据类型
class CoursePlanDataType
    
///一日一题数据类型
class DayTopicDataType
    
///一日一题详情数据类型
class DayTopicDetailDataType
    
/// 考试列表项数据类型
class ExamListDataType
    
/// 考试排行数据类型
class ExamRankingDataType
    
///考试时间线数据类型
class ExamTimeLineDataType
    
/// 专项练习列表数据类型
class ExerciseDataType
    
/// 练习列表数据
class ExerciseSelectDataType
    
///商品数据类型
class GoodsDataType
    
///商品兑换的数据类型
class GoodsExchangeDataType
    
/// 班级信息数据类型
class GradeInfoDataType
    
/// 三违情况数据类型
class IllegalManageDataType
    
///积分规则数据类型
class IntegralRuleDataType
    
///试题的数据类型
class IssueDataType
    
/// 视频的数据类型
class MateriaDataType
    
/// (考试、练习、新闻、课程)导航类型
class NavDataType
    
///新闻数据类型
class NewsDataType
    
/// 考试记录数据类型
class TestRecordsDataType
    
///用户信息数据类型
class UserInfoDataType
    
///消息通知数据类型
class UserMessageDataType
    
/// 考勤记录数据类型
class CheckingInRecordDataType
```



## 接口

```
http://192.168.0.8:88/index.php/v2/test/getTestItemList				考试分类列表导航
http://192.168.0.8:88/index.php/v2/Practice/getPracticeItemList		获取练习分类列表导航
http://192.168.0.8:88/index.php/v2/news/getNewsItemList				新闻分类列表导航
http://192.168.0.8:88/index.php/v2/course/getCourseItemList			课程分类列表导航

http://192.168.0.8:88/index.php/v2/index/indexBanner				轮播图
http://192.168.0.8:88/index.php/v2/user/getUserServiceList			职工服务
```

```dart
[
    {
        "name": "主页",
        "item": [
            {
                "name": "获取最新考试接口",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "user_id",
                                "value": "5016",
                                "type": "text"
                            },
                            {
                                "key": "pid",
                                "value": "4",
                                "type": "text",
                                "disabled": true
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/newKaoshi"
                },
                "response": [
                    
                ]
            },
            {
                "name": "职工课程列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "searchValue",
                                "value": "事故",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "5013",
                                "type": "text"
                            },
                            {
                                "key": "page",
                                "value": "1",
                                "type": "text"
                            },
                            {
                                "key": "psize",
                                "value": "8",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/course/courseList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "课程学习详情",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "course_id",
                                "value": "4",
                                "type": "text"
                            },
                            {
                                "key": "pid",
                                "value": "4",
                                "type": "text",
                                "disabled": true
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/v2/course/courseSituation"
                },
                "response": [
                    
                ]
            },
            {
                "name": "课程详情",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "course_id",
                                "value": "21",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "5011",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/course/courseDetail"
                },
                "response": [
                    
                ]
            },
            {
                "name": "消息通知",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "user_id",
                                "value": "5011",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/getUserMessage"
                },
                "response": [
                    
                ]
            }
        ],
        "protocolProfileBehavior": {
            
        }
    },
    {
        "name": "新闻",
        "item": [
            {
                "name": "获取新闻列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "page",
                                "value": "1",
                                "type": "text"
                            },
                            {
                                "key": "psize",
                                "value": "10",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/news/getIndexNewsList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "新闻详情",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "1",
                                "description": "新闻id",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/news/getNewsOne"
                },
                "response": [
                    
                ]
            },
            {
                "name": "添加新闻收藏",
                "protocolProfileBehavior": {
                    "disableBodyPruning": true
                },
                "request": {
                    "method": "GET",
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "q_id",
                                "value": "1",
                                "description": "新闻id",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "1",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/addNewsCollect"
                },
                "response": [
                    
                ]
            },
            {
                "name": "设置新闻积分",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "news_id",
                                "value": "1",
                                "description": "新闻id",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "1",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/newsUserScore"
                },
                "response": [
                    
                ]
            }
        ],
        "protocolProfileBehavior": {
            
        }
    },
    {
        "name": "课程",
        "item": [
            
        ],
        "protocolProfileBehavior": {
            
        }
    },
    {
        "name": "考试",
        "item": [
            {
                "name": "考试列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "pid",
                                "value": "60",
                                "description": "考试分类id",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "5016",
                                "description": "用户id",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/getTestList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "获取考试考题",
                "request": {
                    "method": "POST",
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "84",
                                "description": "考试id",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "1737",
                                "description": "用户id",
                                "type": "text"
                            },
                            {
                                "key": "type",
                                "value": "2",
                                "description": "1模拟考试2正式考试3补考考试",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/kaoTi"
                },
                "response": [
                    
                ]
            },
            {
                "name": "获取考试信息",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "test_id",
                                "value": "1",
                                "description": "考试id",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/kaoTi"
                },
                "response": [
                    
                ]
            },
            {
                "name": "保存考试结果",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "test_id",
                                "value": "1",
                                "description": "考试id",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "1",
                                "description": "用户id",
                                "type": "text"
                            },
                            {
                                "key": "all",
                                "value": "array",
                                "description": "提交的答案数组",
                                "type": "text"
                            },
                            {
                                "key": "test_type",
                                "value": "1",
                                "description": "1模拟考试2正式考试3补考考试",
                                "type": "text"
                            },
                            {
                                "key": "branch",
                                "value": "100",
                                "description": "得分",
                                "type": "text"
                            },
                            {
                                "key": "type",
                                "value": "1",
                                "description": "考试结果类型1未参加2补考3及格4不及格",
                                "type": "text"
                            },
                            {
                                "key": "test_time",
                                "value": "1606716480000",
                                "description": "考试时间",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/saveUserTest"
                },
                "response": [
                    
                ]
            },
            {
                "name": "获取考试分类列表",
                "protocolProfileBehavior": {
                    "disableBodyPruning": true
                },
                "request": {
                    "method": "GET",
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "pid",
                                "value": "0",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/getTestItemList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "最新考试",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "user_id",
                                "value": "5011",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/test/newKaoshi"
                },
                "response": [
                    
                ]
            }
        ],
        "protocolProfileBehavior": {
            
        }
    },
    {
        "name": "我的",
        "item": [
            {
                "name": "我的课程",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "2",
                                "type": "text"
                            },
                            {
                                "key": "page",
                                "value": "1",
                                "type": "text"
                            },
                            {
                                "key": "psize",
                                "value": "10",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/getUserCourseList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "我的错题",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "4",
                                "type": "text"
                            },
                            {
                                "key": "page",
                                "value": "1",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "psize",
                                "value": "10",
                                "type": "text",
                                "disabled": true
                            }
                        ],
                        "options": {
                            "raw": {
                                "language": "json"
                            }
                        }
                    },
                    "url": "192.168.0.8:86/index.php/v2/user/getUserErrQuestion"
                },
                "response": [
                    
                ]
            },
            {
                "name": "用户考试答题列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "test_id",
                                "value": "52",
                                "type": "text"
                            },
                            {
                                "key": "id",
                                "value": "5011",
                                "type": "text"
                            },
                            {
                                "key": "page",
                                "value": "1",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "test_type",
                                "value": "2",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/getUserTestAnswerList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "战绩排行",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "3",
                                "type": "text"
                            },
                            {
                                "key": "test_id",
                                "value": "1",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/testRankList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "保存用户消息",
                "request": {
                    "body": {
                        "mode": "formdata",
                        "formdata": [
                            
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/saveUserMessage"
                },
                "response": [
                    
                ]
            },
            {
                "name": "个人信息",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "status",
                                "value": "1",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/getUserInfo"
                },
                "response": [
                    
                ]
            },
            {
                "name": "加入班级或者签到",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "class_id",
                                "value": "2",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "5011",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/userAddClass"
                },
                "response": [
                    
                ]
            },
            {
                "name": "用户一日一题列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "5014",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/getTodayUserStudy"
                },
                "response": [
                    
                ]
            },
            {
                "name": "重置密码",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "name",
                                "value": "杨同师",
                                "type": "text"
                            },
                            {
                                "key": "idCard",
                                "value": "340406199001011234",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/resetPassWord"
                },
                "response": [
                    
                ]
            },
            {
                "name": "我的班级",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "user_id",
                                "value": "5011",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/getUserClass"
                },
                "response": [
                    
                ]
            },
            {
                "name": "积分兑换",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "goods_id",
                                "value": "1",
                                "type": "text"
                            },
                            {
                                "key": "score",
                                "value": "1.0",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "5011",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/score/userExchangeScore"
                },
                "response": [
                    
                ]
            },
            {
                "name": "物品列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "page",
                                "value": "",
                                "type": "text"
                            },
                            {
                                "key": "psize",
                                "value": "",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/score/userExchangeScore"
                },
                "response": [
                    
                ]
            },
            {
                "name": "获取积分规则",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/score/userExchangeScore"
                },
                "response": [
                    
                ]
            }
        ],
        "protocolProfileBehavior": {
            
        }
    },
    {
        "name": "练习",
        "item": [
            {
                "name": "获取练习分类列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "pid",
                                "value": "1",
                                "description": "分类id",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/Practice/getPracticeItemList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "获取练习列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "user_id",
                                "value": "1",
                                "type": "text"
                            },
                            {
                                "key": "pid",
                                "value": "2",
                                "description": "分类id",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/Practice/getPracticeList"
                },
                "response": [
                    
                ]
            },
            {
                "name": "获取练习详情",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "2",
                                "description": "练习id",
                                "type": "text"
                            },
                            {
                                "key": "user_id",
                                "value": "1",
                                "description": "用户id",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/Practice/getOnePractice"
                },
                "response": [
                    
                ]
            },
            {
                "name": "保存用户练习",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "user_id",
                                "value": "1",
                                "type": "text"
                            },
                            {
                                "key": "id",
                                "value": "1",
                                "description": "练习id",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/Practice/saveUserPractice"
                },
                "response": [
                    
                ]
            }
        ],
        "protocolProfileBehavior": {
            
        }
    },
    {
        "name": "一日一题",
        "item": [
            {
                "name": "推送",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "name",
                                "value": "",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "page",
                                "value": "0",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "id",
                                "value": "9",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "t",
                                "value": "688F19DC72A0A9EF40CAC99A774911A6",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "nonce",
                                "value": "1599562235",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "sign",
                                "value": "",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "id",
                                "value": "10",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "test_type",
                                "value": "3",
                                "type": "text",
                                "disabled": true
                            },
                            {
                                "key": "test_id",
                                "value": "10",
                                "type": "text",
                                "disabled": true
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v1/push/pushApp"
                },
                "response": [
                    
                ]
            },
            {
                "name": "保存一日一题学习",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "id",
                                "value": "5011",
                                "type": "text"
                            },
                            {
                                "key": "pid",
                                "value": "2397",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/saveTodayStudy"
                },
                "response": [
                    
                ]
            }
        ],
        "protocolProfileBehavior": {
            
        }
    },
    {
        "name": "职工服务",
        "item": [
            {
                "name": "证书列表",
                "request": {
                    "body": {
                        "mode": "urlencoded",
                        "urlencoded": [
                            {
                                "key": "idCard",
                                "value": "340406198001011234",
                                "type": "text"
                            }
                        ]
                    },
                    "url": "http://192.168.0.8:88/index.php/v2/user/getUserCert"
                },
                "response": [
                    
                ]
            }
        ],
        "protocolProfileBehavior": {
            
        }
    }
]
```

