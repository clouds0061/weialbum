import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//进入页面后的等待页面 做一个圆形进度条
class WaitingPage extends StatefulWidget{
  Function function;

  WaitingPage(this.function);

  @override
  State<StatefulWidget> createState()=> WaitingPageState();
}


class WaitingPageState extends State<WaitingPage>{

  double startTime;
  Ticker ticker;
  Widget root;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    root = getRoot();
    ticker = new Ticker(tick);
    ticker.start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ticker.stop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return root;
  }

  //设置计时6秒超时  停止计时器
  tick(Duration d) {
    if(d.inSeconds>4) {
      root = getRootOutOfTime();
      setState(() {
        ticker.stop();
        widget.function(0);
      });
    }
  }

  //返回显示load的widget
  Widget getRoot(){
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
            child: Container(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(),
            ),
        ),
        );
  }

  //返回超时显示的 widget
  Widget getRootOutOfTime(){
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
            child: Image.asset('images/out_of_time.jpeg',width: 60.0,height: 60.0,fit: BoxFit.cover,),
        ),
    );
  }

}