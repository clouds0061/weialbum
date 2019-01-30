import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:umeng/umeng.dart';

class CommonUtils {

  static final String FIRST_IN_APP = 'first_in_app'; //第一次进入app


  static SharedPreferences prefs;

  static Future getSharePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }


  //处理string
  static List<String> getList(String listString) {
    List<String> list = new List();
    List<String> resultList = new List();
    list.addAll(listString.split(';'));
    print('---lastList--- ${list[list.length - 1 ]}');
    list.removeLast();
    getTemporaryDirectory().then((directory) {
      Directory d = new Directory('${directory.path}/img/');
      for (int i = 0; i < list.length; i++) {
        print('----CommonUtils1---- ${list[i]}');
        List<String> listPath = list[i].split('/img/');
        String resultPath = d.path + listPath[1];
        resultList.add(resultPath);
        print('---CommonUtils2--- $resultPath');
      }
    });
    return resultList;
  }

  ///判断是否是pad  传入mode
  static bool isIPad(var name) {
    if (name.toString().contains('Phone'))
      return false;
    else
      return true;

    return false; //测试 返回，需要测试就注释掉上面两行
  }


  static void onEvent(int eventId) {
    switch (eventId) {
      case 0:
        Umeng.onEvent('onShare');
        break;
      case 1:
        Umeng.onEvent('addWaterMark');
        break;
      case 2:
        Umeng.onEvent('fa_bu_dong_tai');
        break;
      case 3:
        Umeng.onEvent('save');
        break;
      case 4:
        Umeng.onEvent('login');
        break;
      case 5:
        Umeng.onEvent('camera');
        break;
      case 6:
        Umeng.onEvent('pictures');
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
    }
  }


}