import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wei_album/model/HomeListModel.dart';
import 'package:wei_album/utils/CommonUtils.dart';
import 'package:wei_album/utils/DbHelper.dart';
import 'package:wei_album/utils/TimeUtils.dart';
import 'package:wei_album/view/ReleasePage.dart';
import 'package:wei_album/widget/PullToRefreshWidget.dart';
import 'package:wei_album/widget/WaitingPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//动态页面
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<HomeListModel> models = new List();
  List<String> strs = new List();
  bool dataReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                title: Text('相册动态',style: TextStyle(color: Colors.black),),
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
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ReleasePage();
                                }));
                          },
                          child: Text(
                              '发布动态', style: TextStyle(fontSize: 15.5,color: Colors.black),),
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
        models.add(new HomeListModel(headUrl, nick_name, commodity_content,
            CommonUtils.getList(listUrls), TimeUtils.getTimeInDetails(releaseDate),
            TimeUtils.getTimeInDetails(shareDate)));
      }
    });
    print('----models----$models');
    return models;
  }

}
