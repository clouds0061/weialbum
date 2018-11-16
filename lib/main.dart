import 'package:flutter/material.dart';
import 'package:wei_album/SplashPage.dart';
import 'package:wei_album/utils/DbHelper.dart';
import 'package:wei_album/view/LoginPage.dart';
import 'package:flutter/services.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    DbHelper.getInstance().initDataBase('weialbum').then((data){
//      DbHelper.getInstance().insert2('"www.headUrl.com"','"小马"','"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"','"imgs"','"20181114"','"20181114"');
//      DbHelper.getInstance().insert2('1','1','1','1','1','1');
    });
//    DbHelper.getInstance().openDataBase('weialbum');
    return MaterialApp(
        title: '',
        theme: new ThemeData(
            primarySwatch: Colors.blue,
            ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{ // 路由
          '/LoginPage': (BuildContext context) => LoginPage()
        },
    );
  }

}
