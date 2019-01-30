import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:wei_album/utils/CommonUtils.dart';
import 'package:wei_album/utils/TimeUtils.dart';


class DbHelper {

  static final String _dbName = 'weialbum';
  static final String tableName = 'ALBUM';

  static DbHelper _dbHelper;

  static DbHelper getInstance() {
    if (_dbHelper == null) _dbHelper = new DbHelper();
    return _dbHelper;
  }

  Database _dataBase;

//  String path =

  /*String head_portrait_url;//头像url
  String nick_name;//昵称
  String commodity_content;//商品内容
  List<String> listUrls;//商品图片url集合
  String releaseDate;//发布日期
  String shareDate;//分享日期*/

  /*初始化数据库*/
  Future initDataBase(String dbName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool flag = sharedPreferences.getBool(CommonUtils.FIRST_IN_APP);
    print('----flag----$flag');
    if (flag == null) flag = false;

    var _dataBasePath = await getDatabasesPath();
//    var _dataBasePath = (await getTemporaryDirectory()).path;
    String path = join(_dataBasePath, dbName);
    if (await Directory(dirname(path)).exists()) {
      if (!flag) { //如果第一进入app 需要进行一下操作
        await deleteDatabase(path).then((_) async { //删除 然后重建库和表
          try {
            await Directory((dirname(path))).create(recursive: true);
            _dataBase = await openDatabase(
                path, version: 1, onCreate: (Database db, int version) async {
              await db.execute(
                  "CREATE TABLE $tableName (head_portrait_url TEXT,nick_name TEXT,"
                      " commodity_content TEXT,listUrls TEXT,releaseDate TEXT,shareDate TEXT,time TEXT)");
            });
            print('----dataBase 2----$_dataBase');
            sharedPreferences.setBool('${CommonUtils.FIRST_IN_APP}', true);
          } catch (e) {
            print('----dataBase 3----$_dataBase');
            print(e);
          }
        });
      } else {
        print('----dataBase is exists already----');
        openDataBase('');
      }
    } else {
      try {
        await Directory((dirname(path))).create(recursive: true);
        _dataBase = await openDatabase(
            path, version: 1, onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE $tableName (head_portrait_url TEXT,nick_name TEXT,"
                  " commodity_content TEXT,listUrls TEXT,releaseDate TEXT,shareDate TEXT,time TEXT)");
        });
        print('----dataBase 2----$_dataBase');
      } catch (e) {
        print('----dataBase 3----$_dataBase');
        print(e);
      }
    }

//      await deleteDatabase(path).then((_) async{});
//      _dataBase = await openDatabase(path, version: 1);
//      print('----dataBase 1----$_dataBase');
//    }
//    else {
//    }
  }

  /*打开数据库*/
  Future<Object> openDataBase(String dbName) async {
    var _dataBasePath = await getDatabasesPath();
//    var _dataBasePath = (await getTemporaryDirectory()).path;
    String path = join(_dataBasePath, _dbName);
    _dataBase = await openDatabase(path, version: 1);
    print('----dataBase----$_dataBase');
    return path;
  }

  /*插入数据*/
  insert(String head_portrait_url, String nick_name, String commodity_content,
      String listUrls, String releaseDate, String shareDate) async {
    String time = TimeUtils.getNowTimeyyyy_MM_dd_HH_mm_ss();
//    if(_dataBase == null) openDataBase(_dbName);
    await _dataBase.transaction((txn) async {
      await txn.rawInsert(
          "INSERT INTO $tableName(head_portrait_url,nick_name,commodity_content,listUrls,releaseDate,shareDate,time) "
              " VALUES ($head_portrait_url,$nick_name,$commodity_content,$listUrls,$releaseDate,$shareDate,$time)");
    });
  }

  /*插入数据*/
  insert2(String head_portrait_url, String nick_name, String commodity_content,
      String listUrls, String releaseDate, String shareDate) async {
    print('----dataBase 4----$_dataBase');
    String time = TimeUtils.getNowTimeyyyy_MM_dd_HH_mm_ss();
    if (_dataBase == null) openDataBase(tableName);
    _dataBase.rawInsert(
        "INSERT INTO $tableName(head_portrait_url,nick_name,commodity_content,listUrls,releaseDate,shareDate,time)"
            "VALUES($head_portrait_url,$nick_name,$commodity_content,$listUrls,$releaseDate,$shareDate,$time)");
  }

  /*查找所有数据*/
  Future<List<Map<String, dynamic>>> query() async {
    List<Map<String, dynamic>> list = await _dataBase.rawQuery(
        "SELECT * FROM $tableName");
    return list;
  }

  /*更新数据*/
  upData(String time, String shareDate) async {
    String sql = 'UPDATE $tableName SET shareDate = ? WHERE time = ?';
    _dataBase.rawUpdate(sql, ["$shareDate", "$time"]);
  }

}