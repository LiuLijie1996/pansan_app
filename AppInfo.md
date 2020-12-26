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
informAffiche				通知公告
login						登录、注册、忘记密码
searchCourseList			课程列表
settings					设置页面
staffServe					职工服务
testRecords					考试记录
updatePwd					修改密码
newsDetail					新闻详情
courseDetail				课程详情
searchPage					搜索页

myAdvisory					我的咨询
advisoryDetail				咨询信息详情
myCollect					我的收藏
myCourse					我的课程
myGrade						我的班级
myInformation				个人信息
myMistakes					我的错题

integralCentre				积分中心
integralDetails				积分明细
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

### banner图类型：BannerDataType

```dart
{
    "id": 2,//banner的id
    "name": "22",//banner标题
    "type_link": 1,//链接类型 0不跳转  1考试分类  3练习分类  2课程列表  4考试列表  5新闻详情
    "link": "2",//分类id 或 列表id
    "thumb_url": "http://192.168.0.8:88/uploads/image/20201218/1608275103433.jpeg",//封面图
    "addtime": 1608275353,//添加时间
    "news_type": 0 //新闻类型 1图文  2视频
}
```

### 一日一题类型

```dart
{
    "time": 1606752000,//时间线上的时间
    "child": [//时间线上的成员列表
        {
            "status": 2,//状态 1已学习  2未学习
            "name": "就OK",//标题
            "id": 1,//id
            "study_time": 1608307200//具体时间
        }
    ]
}
```



### 考试列表项信息类型：ExamListDataType

```dart
{
    "id": 172,//列表项id
    "pid": 2,//分类id
    "m_test_id": 0,//补考id
    "class_id": 0,//班级id
    "paper_id": 79,//试卷id
    "name": "测试考试审核",//考试标题
    "address": "555",//考试地址
    "start_time": 1608048000,//开始时间
    "end_time": 1609344000,//结束时间
    "duration": 20.00,//考试时长
    "passing_mark": 50.00,//及格分数
    "test_num": 1,// 考试次数  0无限
    "cut_screen_type": 0,//是否开启切屏  0未开启  1开启
    "cut_screen_num": 1,//切屏次数
    "cut_screen_time": 10,//切屏时间
    "type": 2,// 1模拟考试  2正式考试  3补考
    "is_test": true//是否可以考试
}
```

### 考试题目类型：IssueDataType

```json
{
  "id": 13505,//题目id
  "pid": 114,//考试分类id
  "name": "2020年10月月考题库",//考试名称
  "type": 3,// 1单选 3判断 2多选 4填空
  "stem": "采掘工作面的空气温度超30℃，机电设备硐室的空气温度超过34℃时，必须停止作业。（对）",//题目名称
  "option": [//答案可选项
    {
      "label": "A",
      "value": "对"
    },
  ],
  "answer": ["A"],//正确答案
  "analysis": "",//答案解析
  "addtime": 1602836160,//添加考试时间
  "disorder": 5,//当前题目分数
  "userFavor": false,//用户是否收藏
  "userAnswer": ["A"],//用户选择的答案
  "correct": true//用户选择的答案是否正确
}
```

### 新闻列表项、新闻详情：NewsDataType

```dart
{
    "id": 188,//新闻id
    "pid": 2,//导航id
    "title": "矿安全改建及二水平延深工程顺利通过竣工验收",//标题
    "desc": "矿安全改建及二水平延深工程顺利通过竣工验收",//简介
    "thumb_url": "http://pansan_api.fangda.net.cn/uploads/image/20201211/1607690197838.",//封面
    "type": 1,//新闻类型 1图文  2视频
    "materia_id": 123,//资源id
    "content": "",//文章内容
    "tuij": 0,//是否推荐 0不推荐 1推荐
    "addtime": 1607690231,//新闻添加时间
    "view_num": 3865,//观看次数
    "materia": null, //视频链接
    "newsImgText": 1000,//阅读图文有效时间：1000字60秒
    "newsVideo": 20,//视频有效观看时间 单位：秒
    "collect": false,//是否收藏
}
```

### html

```html
<p><img src="http://pansan_api.fangda.net.cn/uploads/image/20201211/20201211183707_36279.jpg"></p><p>（本网讯）12月11日，集团公司验收委员会对我矿安全改建及二水平延深工程进行竣工验收。在听取有关汇报、分组查看现场及查阅相关资料后，验收委员会一致同意通过我矿安全改建及二水平延深工程竣工验收。集团公司党委副书记、总经理王世森出席竣工验收会议并讲话。</p><p><br></p><p>集团公司副总经理韩家章主持竣工验收会议。煤业公司党委副书记、总经理胡少银，矿长陈士虎、矿党委书记王晓峰在三楼东会议室迎接验收委员会一行。</p><p><br></p><p>王世森首先对验收委员会各专家的到来表示欢迎，并对各专家的辛勤劳动表示感谢。他指出，当前集团公司正沿着煤、电、气三大能源主业的产业链、服务链、价值链，深化改革创新，加快转型升级，奋力打造现代大型综合能源服务集团。企业目前正加快推进组织管控模式调整和人力资源薪酬改革等重点工作，生产经营形势平稳有序。</p><p><br></p><p>王世森表示，在经过上一轮去产能后，煤炭企业将在更高层面上展开竞争，因此科学编制生产接替规划十分重要。近几年，本土煤业重点在进一步做强做精上下功夫，认真谋划存续矿井的未来发展，潘三矿安全改建及二水平延深工程项目是集团公司综合考量的重点项目，项目建设对本土煤矿解决提升能力不足和采场接替等问题意义重大，将为矿井安全高效可持续开采蓄能。他要求，此次通过竣工验收后，相关部门和单位要认真研究、抓紧落实本次验收会提出的意见和建议，确保项目顺利运行，为加快建设现代大型综合能源服务集团作出新的更大贡献。</p><p><br></p><p>韩家章指出，此次通过竣工验收，标志着项目建设圆满收官，进入正常运行管理、全面发挥效益的新阶段，作为淮南本土主力矿井，潘三矿建设安全改建及二水平延深工程，能够解决矿井安全、提升运输能力、采场接替三大问题，促进矿井安全稳产，对保障矿井安全高效开采和可持续发展具有重要意义，向淮河能源控股集团第一次党代会献上了一份厚礼。下一步，对相关工程的竣工验收，要严格按相关管理办法组织验收，细化资料准备，确保验收依法依规、合法有效。</p><p><br></p><p>胡少银代表煤业公司对验收委员会及各位专家来潘三矿开展安全改建及二水平延深工程项目竣工验收表示感谢。他指出，潘三矿安全改建及二水平延深工程建设历时近十年，在相关领导的大力支持和关心下，完成了集团公司制定的年底前完成项目竣工验收的目标。对于专家组指出的问题，要严格按要求落实整改，举一反三，全面提升煤业公司在工程建设领域的管理水平。</p><p><br></p><p>会上，省能源局煤炭处相关负责人发言，专家组组长宣读竣工验收专家组意见，集团公司资深专家宣读竣工验收结论。集团公司资深专家，集团公司、煤业公司部分机关部门、服务支持机构，矿副总以上领导参加验收会议。（于晨晨 陈恩文）</p>
```

### 课程数据类型：CourseDataType

```dart
{
    "id": 155,//课程id
    "pid": 7,//导航id
    "name": "110工法",//标题
    "desc": "110工法",//简介
    "content": "",//课程介绍
    "addtime": 1606957998,//添加时间
    "thumb_url": "http://pansan_api.fangda.net.cn/uploads/image/20201203/1606957369298.",//封面
    "study_status": 2,//学习状态 1已学完 2未学习 3学习中
    "chapter": [//章节列表信息
        {
            "id": 175,//章节id
            "d_id": 0,//部门id
            "pid": 155,//分类id
            "name": "默认章节",//章节名称
            "addtime": 1606308351,//添加时间
        }
    ],
    "view_num": 233//在学人数
}
```

### (考试、练习、新闻、课程)导航类型：NavDataType

```dart
{
    "id": 2,//导航id
    "d_id": 0,//部门id
    "pid": 1,//父级导航id
    "name": "一月一考",//导航标题
    "children": [//子导航
        "id": 2,//导航id
        "d_id": 0,//部门id
        "pid": 1,//父级导航id
        "name": "一月一考",//导航标题
    ]
}
```

### 咨询类型  AdvisoryDataType

```dart
{
    "id": 72,
    "pid": 1,
    "user_id": 1705,
    "title": "查三违",
    "content": "11月份较严重三违人员名单",
    "link": "",
    "key": "",
    "addtime": 1606904780,
    "status": 1,
    "audit": 1,
    "transfer_id": 0,
    "reply": [
        {
            "id": 1,
            "pid": 72,
            "content": "可以的",
            "addtime": 1608350026
        }
    ]
}
```

### 证书类型  CertificateDataType

```dart
{
    "id": 18290,
    "idCard": "TM340405197805100433",
    "name": "随贡献",
    "dep": "通风区",
    "addtime": 1605755116
}
```

### 三违情况类型  IllegalManageDataType

```dart
{
    "id": 73,
    "pid": 3,
    "user_id": 0,
    "title": "11月23-30日三违统计",
    "content": "11月23-30日三违统计",
    "link": "http://pansan_api.fangda.net.cn/uploads/654e228b599ce90c2da0af22f845f876.doc",
    "key": "doc/20201203/654e228b599ce90c2da0af22f845f876.doc",
    "addtime": 1606956515,
    "status": 1,
    "audit": 1,
    "transfer_id": 0
}
```

### 练习列表数据类型：ExerciseSelectDataType

```dart
{
    "id": 2,
    "d_id": 2,
    "pid": 2,
    "name": "子管理员1",
    "radio": 2,//单选题个数
    "multiple": 20,//多选题个数
    "trueOrFalse": 20,//判断题个数
    "practice_num_type": 3,//练习次数 1无限  2一次  3多次
    "frequency": 20,//答题次数
    "q_id": "7,4",//题目id
    "addtime": 1606723039,//添加时间
    "status": 1,
    "sorts": "",
    "is_practice": true,//是否能点击
}
```

### 专项练习



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

