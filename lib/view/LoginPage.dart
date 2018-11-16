import 'package:flutter/material.dart';
import 'package:wei_album/view/HomePage.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: '',
        home: new Scaffold(
            appBar: AppBar(title: Text('login'),),
            body: Container(
                alignment: Alignment.center,
                color: Colors.blue,
                child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
                        return HomePage();
                      }));
                    },
                child: Icon(Icons.format_align_justify),
                ),
            ),
        ),
    );
  }




}