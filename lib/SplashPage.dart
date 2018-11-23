import 'package:flutter/material.dart';
import 'package:wei_album/utils/DbHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();

}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences =  null;
    DbHelper.getInstance().initDataBase('weialbum').then((data){
//      DbHelper.getInstance().insert2('"www.headUrl.com"','"小马"','"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"','"imgs"','"20181114"','"20181114"');
//      DbHelper.getInstance().insert2('1','1','1','1','1','1');
    });
    // TODO: implement build
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
            child: Image.asset('images/mom3.png',fit: BoxFit.cover,),
        ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDown();
  }

  void countDown() {
    var _duration = new Duration(seconds: 3);
    new Future.delayed(_duration, go2HomePage);
  }

  void go2HomePage() {
    Navigator.of(context).pushReplacementNamed('/LoginPage');
  }
}