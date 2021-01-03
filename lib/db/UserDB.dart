import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/UserInfoDataType.dart';

///用户数据库
abstract class UserDB {
  ///数据库名称
  static final name = "PanSanBase.db";

  ///表名称
  static final table = "userInfo";

  ///数据库版本号 用于控制表结构升级
  static final version = 1;

  ///新增字段
  static final newKey = 'integral';

  /// 连接数据库
  static Future<Database> database() async {
    // 获取数据库地址
    String dataPath = await getDatabasesPath();

    // 拼接数据库路径
    String dbPath = path.join(dataPath, UserDB.name);

    // 获取数据库
    var database = openDatabase(
      ///数据库地址
      dbPath,

      ///数据库版本
      version: UserDB.version,

      /// 创建表
      onCreate: UserDB.onCreate,

      onUpgrade: UserDB.onUpgrade,
    );

    return database;
  }

  /// 创建表
  static onCreate(db, version) async {
    print("创建表,版本号为：$version");
    db.execute('''CREATE TABLE ${UserDB.table}(
          id INTEGER PRIMARY KEY, 
          pid int,
          name TEXT,
          password TEXT,
          headUrl TEXT,
          sex int,
          integral int,
          birthday int,
          idCard TEXT,
          No TEXT,
          phone TEXT,
          department TEXT,
          education TEXT,
          title TEXT,
          job TEXT,
          type_work TEXT,
          politics_status TEXT,
          party_time TEXT,
          native TEXT,
          addtime int,
          status int,
          token TEXT,
          expire_time int,
          cid TEXT,
          jobtime int,
          job_work TEXT,
          skill_level TEXT,
          bindPhone int
        )''');
  }

  static onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      var batch = db.batch();
      print("updateTable version $oldVersion $newVersion");
      batch.execute(
        'alter table ${UserDB.table} add column ${UserDB.newKey} int',
      );
      await batch.commit();
    }
  }

  /// 存储数据
  static Future<int> addData(UserInfoDataType data) async {
    // 建立连接
    final Database db = await database();

    // 插入数据
    int id = await db.insert(
      '${UserDB.table}',
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("保存用户信息成功");

    return id;
  }

  /// 获取所有数据
  static Future<List<UserInfoDataType>> findAll() async {
    // 建立连接
    final Database db = await database();

    // 获取所有数据
    List<Map<String, dynamic>> maps = await db.query('${UserDB.table}');

    // 格式化数据
    return List.generate(
      maps.length,
      (index) {
        return UserInfoDataType.fromJson(maps[index]);
      },
    );
  }

  // 修改数据
  static Future<UserInfoDataType> update(UserInfoDataType data) async {
    // 建立连接
    final Database db = await database();

    // 修改数据
    await db.update(
      "${UserDB.table}", //数据表
      data.toJson(), //新数据
      where: "id=${data.id}", //查询条件
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("修改用户信息成功");
  }

  /// 删除数据
  static Future delete() async {
    // 建立连接
    final Database db = await database();

    // 删除数据
    await db.delete("${UserDB.table}");

    print("删除用户信息成功");
  }

  /// 关闭数据库
  static Future<void> dispose() async {
    final Database db = await database();
    db.close();
  }
}
