import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils {

  static SharedPreferences prefs;

  static Future getSharePreferences() async{
    prefs = await SharedPreferences.getInstance();
  }



  //处理string
  static List<String> getList(String listString) {
    List<String> list = new List();
    list.addAll(listString.split(';'));
    return list;
  }

  ///判断是否是pad  传入mode
  static bool isIPad(var name) {
    if(name.toString().contains('Phone')) return false;
    else return true;

    return false;//测试 返回，需要测试就注释掉上面两行
  }

}