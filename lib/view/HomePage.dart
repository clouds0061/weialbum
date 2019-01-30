import 'package:flutter/material.dart';
import 'package:wei_album/model/HomeListModel.dart';
import 'package:wei_album/utils/CommonUtils.dart';
import 'package:wei_album/utils/DbHelper.dart';
import 'package:wei_album/utils/TimeUtils.dart';
import 'package:wei_album/view/ReleasePage.dart';
import 'package:wei_album/widget/PullToRefreshWidget.dart';
import 'package:wei_album/widget/WaitingPage.dart';
import 'package:device_info/device_info.dart';
import 'package:umeng/umeng.dart';

//动态页面
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<HomeListModel> models = new List();
  List<String> strs = new List();
  bool dataReady = false;
  String name = '';
  final DeviceInfoPlugin infoPlugin = new DeviceInfoPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeviceName().then((string){

    });
    initData().then((data) {
      setState(() {
        dataReady = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dataReady = false;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: '',
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text('相册动态', style: TextStyle(color: Colors.black),),
                centerTitle: true,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        color: Colors.transparent,
                        width: 35.0,
                        height: 35.0,
                        child: Image.asset('images/1xback.png'),
                        ),
                    ),
                actions: <Widget>[
                  Center(
                      child: GestureDetector(
                          onTap: () { //跳转到发布页面
                            CommonUtils.onEvent(2);
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ReleasePage();
                                }));
                          },
                          child: Text(
                              '发布动态', style: TextStyle(
                              fontSize: 15.5, color: Colors.black),),
                          ),
                      ),
                ],
                ),
            body: buildLayout(),
            ),
        );
  }


  Widget buildLayout() {
    if (strs.isEmpty) {
      for (int i = 0; i < 9; i++) {
        strs.add('$i');
      }
    }
    if (dataReady) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          child: PullToRefreshWidget(models),
          );
    } else {
      return WaitingPage((result) {

      });
    }
  }

  //初始化数据
  Future<Object> initData() async {
//    Dio dio = new Dio();
//    Response response = await dio.get('https://www.baidu.com');
//    if (response.request != null) {
//      for (int i = 0; i < 9; i++) {
//        models.add(new HomeListModel('$i'));
//        strs.add('$i');
//      }
//    }
    DbHelper.getInstance().query().then((result) {
      print('-----queryResult----${result.toString()}');
      for (int i = 0; i < result.length; i++) {
        String headUrl = result[i]['head_portrait_url'];
        String nick_name = result[i]['nick_name'];
        String commodity_content = result[i]['commodity_content'];
        String listUrls = result[i]['listUrls'];
        String releaseDate = result[i]['releaseDate'];
        String shareDate = result[i]['shareDate'];
        String time = result[i]['time'];






        models.add(new HomeListModel(headUrl, nick_name, commodity_content,
            CommonUtils.getList(listUrls),
            TimeUtils.getTimeInDetails(releaseDate),
            TimeUtils.getTimeInDetails(shareDate),time));
      }
    });
    print('----models----$models');
    return models;
  }

  void init() {}

  //获取设备信息
  Future<String> initDeviceName() async {
    print('******step******: 2');
    try {
      name = (await infoPlugin.iosInfo).model;
    } catch (Exception) {
      name = 'Failed to get device name';


    } finally {
      setState(() {
        if (CommonUtils.isIPad(name)) {
          initUmeng(1);
        } else {
          initUmeng(2);
        }
      });
    }
    return name;
  }

  void initUmeng(int i) async {
    if (i == 1) {
      String res = await Umeng.initUmIos("5bfd35f5f1f556c2e500038d", ""); //ipad
      print('iPad:$res');
    } else {
      String res = await Umeng.initUmIos(
          "5bfd35f5f1f556c2e500038d", ""); //iPhone
      print('iPhone:$res');
    }

    String _string;
    try {
      //第一个参数是wxAppId 第二个参数是微博的AppId
      _string = await Umeng.initWXShare("wx37bb53e81c347aad", "3470678730");
    } on Exception {
      _string = 'wxShare failed!';
    }
  }
}
