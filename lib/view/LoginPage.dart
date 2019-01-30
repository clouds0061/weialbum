import 'package:flutter/material.dart';
import 'package:wei_album/utils/ColorUtils.dart';
import 'package:wei_album/view/HomePage.dart';
import 'package:wei_album/utils/CommonUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: '',
        home: new Scaffold(
            appBar: AppBar(
                title: Text('微商相册', style: TextStyle(
                    color: Color(ColorUtils.colorTextBlackFF020202)),),
                backgroundColor: Colors.white,),
            body: Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: GestureDetector(
                    onTap: () {
//                      CommonUtils.onEvent(4);//login
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HomePage();
                          }));
                    },
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Stack(children: <Widget>[
                          Align(alignment: Alignment.center,
                              child: Container(
                                  margin: EdgeInsets.only(top: 120.0),
                                  width: 240.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white
                                  ),
                                  child: Tooltip(
                                      message: '',
                                      child: Center(child: Text('游客登陆'),),
                                      ),
                                  ),),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 60.0),
                                  child: Image.asset('images/Appicon.png',width: 100.0,height: 100.0,),
                              ),
                              ),
                        ],),
                        ),
                    ),
                ),
            ),
        );
  }


}