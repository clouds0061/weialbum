import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulltorefresh_flutter/pulltorefresh_flutter.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:wei_album/model/HomeListModel.dart';
import 'package:wei_album/utils/CommonUtils.dart';
import 'package:wei_album/utils/DbHelper.dart';
import 'package:wei_album/utils/TimeUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:umeng/umeng.dart';

class PullToRefreshWidget extends StatefulWidget {
  List<String> strs = new List();
  List<HomeListModel> models = new List();

  PullToRefreshWidget(list) {
    models.addAll(list);
  }

  @override
  State<StatefulWidget> createState() => PullToRefreshWidgetState(models);
}

class PullToRefreshWidgetState extends State<PullToRefreshWidget>
    with TickerProviderStateMixin {
  List<String> addStrs = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
  ];

//  List<String> strs = ["1", "2", "3", "4", "5", "6"];
  List<HomeListModel> models = new List();
  List<Widget> widgets = new List();

//  List<String> strs = new List();

  ScrollController controller = new ScrollController();

  //为了兼容ios 必须使用RefreshAlwaysScrollPhysics
  ScrollPhysics scrollPhysics = new RefreshAlwaysScrollPhysics();

  //使用系统的请求
//  var httpClient = new HttpClient();
  var url = "https://github.com/";
  var _result = "";
  String customRefreshBoxIconPath = "images/pull.jpeg";
  AnimationController customBoxWaitAnimation;
  double rotationAngle = 0.0;
  String customHeaderTipText = "下拉刷新!";
  String customFooterTipText = "上拉加载!";
  String defaultRefreshBoxTipText = "放手后刷新!";
  TriggerPullController triggerPullController = new TriggerPullController();

  Dio dio = new Dio();
  bool loadDataSuccess = false;

  PullToRefreshWidgetState(this.models);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    strs.addAll(strs);
    //这个是刷新时控件旋转的动画，用来使刷新的Icon动起来
//    for(int i=0;i<8;i++){
//      widgets.add(buildListItem(i));
//    }
    customBoxWaitAnimation = new AnimationController(
        duration: const Duration(milliseconds: 1000 * 100), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = new ScreenUtil(width: 1242, height: 2208)
      ..init(context);
    triggerPullController.pullAndPushState = new PullAndPushState();
    // TODO: implement build
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: PullAndPush(
        //下拉列表默认头部
            triggerPullController: triggerPullController,
            defaultRefreshBoxTipText: defaultRefreshBoxTipText,
        //下拉列表头部
            headerRefreshBox: buildHeaderRefreshBox(customHeaderTipText),
            footerRefreshBox: buildHeaderRefreshBox(customFooterTipText),
        //获取数据callback、
            animationStateChangedCallback: (AnimationStates animationStates,
                RefreshBoxDirectionStatus refreshBoxDirectionStatus) {
              switch (animationStates) {
              //RefreshBox高度达到50,上下拉刷新可用;RefreshBox height reached 50，the function of load data is  available
                case AnimationStates.DragAndRefreshEnabled:
                  setState(() {
                    //3.141592653589793是弧度，角度为180度,旋转180度；3.141592653589793 is radians，angle is 180⁰，Rotate 180⁰
                    rotationAngle = 3.141592653589793;
                  });
                  break;

              //开始加载数据时；When loading data starts
                case AnimationStates.StartLoadData:
                  setState(() {
                    customRefreshBoxIconPath = "images/refresh.png";
                    customHeaderTipText = "正在加载...";
                    customFooterTipText = "正在加载...";
                  });
                  customBoxWaitAnimation.forward();
                  break;

              //加载完数据时；RefreshBox会留在屏幕2秒，并不马上消失，这里可以提示用户加载成功或者失败
              // After loading the data，RefreshBox will stay on the screen for 2 seconds, not disappearing immediately，Here you can prompt the user to load successfully or fail.
                case AnimationStates.LoadDataEnd:
                  customBoxWaitAnimation.reset();
                  setState(() {
                    rotationAngle = 0.0;
                    if (loadDataSuccess) {
                      if (refreshBoxDirectionStatus ==
                          RefreshBoxDirectionStatus.PULL) {
                        customRefreshBoxIconPath = "images/success.jpeg";
                        customHeaderTipText = "加载成功!";
                      } else if (refreshBoxDirectionStatus ==
                          RefreshBoxDirectionStatus.PUSH) {
                        customRefreshBoxIconPath = "images/success.jpeg";
                        customFooterTipText = "加载成功!";
                      }
                    } else {
                      if (refreshBoxDirectionStatus ==
                          RefreshBoxDirectionStatus.PULL) {
                        customRefreshBoxIconPath = "images/fail.jpg";
                        customHeaderTipText = "加载失败！请重试";
                      } else if (refreshBoxDirectionStatus ==
                          RefreshBoxDirectionStatus.PUSH) {
                        customRefreshBoxIconPath = "images/fail.jpg";
                        customFooterTipText = "加载失败！请重试";
                      }
                    }
                  });
                  break;

              //RefreshBox已经消失，并且闲置；RefreshBox has disappeared and is idle
                case AnimationStates.RefreshBoxIdle:
                  setState(() {
                    customRefreshBoxIconPath = "images/pull.jpeg";
                    customHeaderTipText = "下拉刷新!";
                    customFooterTipText = "上拉加载!";
                  });
                  break;
              }
            },
        //构建列表
            listView: buildListView(),
        //下拉获取数据
            loadData: (isPullDown) async {
              try {
                DbHelper.getInstance().query().then((result) {
                  List<HomeListModel> list = new List();
                  if (result != null) {
                    for (int i = 0; i < result.length; i++) {
                      String headUrl = result[i]['head_portrait_url'];
                      String nick_name = result[i]['nick_name'];
                      String commodity_content = result[i]['commodity_content'];
                      String listUrls = result[i]['listUrls'];
                      String releaseDate = result[i]['releaseDate'];
                      String shareDate = result[i]['shareDate'];
                      String time = result[i]['time'];
                      list.add(new HomeListModel(
                          headUrl,
                          nick_name,
                          commodity_content,
                          CommonUtils.getList(listUrls),
                          TimeUtils.getTimeInDetails(releaseDate),
                          TimeUtils.getTimeInDetails(shareDate),
                          time));
                      print('----list----$list');
                      print('----releaseDate----$releaseDate');
                      setState(() {
//                    //拿到数据后，对数据进行梳理
                        if (isPullDown) {
                          models.clear();
                          models.addAll(list);
                          print('----models----$models');
                        }
//                        else {
//                          models.addAll(list);
//                        }
                        loadDataSuccess = true;
                      });
                    }
                  }
                });
//                var response = await dio.get('http://www.baidu.com');
//                if (response.statusCode == HttpStatus.ok) {
//                  _result = response.statusCode.toString();
//                  setState(() {
//                    //拿到数据后，对数据进行梳理
//                    if (isPullDown) {
//                      strs.clear();
//                      strs.addAll(addStrs);
//                    } else {
//                      strs.addAll(addStrs);
//                    }
//                    loadDataSuccess = true;
//                  });
//                } else {
//                  _result = 'error code : ${response.statusCode}';
//                }
              } catch (exception) {
                _result = '网络异常';
              }
              print(_result);
            },
            scrollPhysicsChanged: (ScrollPhysics physics) {
              //这个不用改，照抄即可；This does not need to change，only copy it
              setState(() {
                scrollPhysics = physics;
              });
            },
            ),
        );
  }


  //列表头部
  Widget buildHeaderRefreshBox(String text) {
    return new Container(
        color: Colors.grey,
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Align(
                  alignment: Alignment.centerLeft,
                  child: new Transform(
                      origin: new Offset(45.0 / 2, 45.0 / 2),
                      transform: Matrix4.rotationX(rotationAngle),
                      child: new RotationTransition( //布局中加载时动画的weight
                          child: new ClipRect(
                              child: new Image.asset(
                                  customRefreshBoxIconPath,
                                  height: 45.0,
                                  width: 45.0,
                                  ),
                              ),
                          turns: new Tween(
                              begin: 100.0,
                              end: 0.0
                          )
                              .animate(customBoxWaitAnimation)
                            ..addStatusListener((animationStatus) {
                              if (animationStatus ==
                                  AnimationStatus.completed) {
                                customBoxWaitAnimation.repeat();
                              }
                            }
                            ),
                          ),
                      ),
                  ),

              new Align(
                  alignment: Alignment.centerRight,
                  child: new ClipRect(
                      child: new Text(text, style: new TextStyle(
                          fontSize: 18.0, color: Color(0xffe6e6e6)),),
                      ),
                  ),
            ],
            )
    );
  }

  //列表
  Widget buildListView() {
//    return CustomScrollView(
//        physics: ScrollPhysics(),
//        slivers:<Widget>[
//          SliverToBoxAdapter(
//              child: _buildListHeader(),
//          ),
//          SliverFixedExtentList(
//              itemExtent: 420.0,
//              delegate: SliverChildListDelegate(widgets),
//          ),
//        ],
//    );
    print('----length----${models.length}');
    int count = models.length + 1;
    return ListView.builder(
    //ListView的Item
        itemCount: count, //+1,
        controller: controller,
        physics: scrollPhysics,
        itemBuilder: buildList,
        );
  }

  //不同item给 不同的布局
  Widget buildList(BuildContext context, int index) {
    if (index == 0)
      return _buildListHeader();
    else
      return buildListItem(context, index);
  }

  //列表item
  Widget buildListItem(BuildContext context, int index) {
    /*不同图片 图片的给的高宽不一样，gridview的高度不一样*/
    double girdHeight = ScreenUtil().setHeight(640);
    double gridItemPicWidth = ScreenUtil().setWidth(315);
    double gridItemPicHeight = ScreenUtil().setHeight(315);
    int crossAxisCount = 3;

    String url = models[index - 1].head_portrait_url;
    List<String> listPath = models[index - 1].listUrls;
    try {
      if (listPath[listPath.length - 1] == null ||
          listPath[listPath.length - 1].isEmpty) listPath.removeLast();
      print('=====listPath=====$listPath');
    } catch (e) {

    }
    int girdCount = listPath.length;
    print('////girdCount////$girdCount');
    if (girdCount == 1) {
      girdHeight = ScreenUtil().setHeight(640);
      gridItemPicWidth = ScreenUtil().setWidth(640);
      gridItemPicHeight = ScreenUtil().setHeight(640);
      crossAxisCount = 1;
    } else if (girdCount > 1 && girdCount <= 3) {
      girdHeight = ScreenUtil().setHeight(320);
      gridItemPicWidth = ScreenUtil().setWidth(315);
      gridItemPicHeight = ScreenUtil().setHeight(315);
    } else if (girdCount > 3 && girdCount <= 6) {
      girdHeight = ScreenUtil().setHeight(640);
      gridItemPicWidth = ScreenUtil().setWidth(315);
      gridItemPicHeight = ScreenUtil().setHeight(315);
    }

    String releaseDate = models[index - 1].releaseDate;
    String shareDate = models[index - 1].shareDate;
    print('=====shareDate=====$shareDate');
    return Container(
        child: Column(children: <Widget>[
          //第一部分包括 头像，昵称和商品介绍
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(51),
                  right: ScreenUtil().setWidth(21)),
              width: double.infinity,
              height: ScreenUtil().setHeight(354),
              child: Row(children: <Widget>[
                //左上角 圆形头像
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(21)),
                        child: ClipOval(
                            child: Image.network(
                                url,
                                width: ScreenUtil().setWidth(145),
                                height: ScreenUtil().setHeight(145),
                                fit: BoxFit.cover,),
                            ),
                        ),
                    ),
                //右边 文字;昵称和商品介绍
                Expanded(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(11),
                                      left: ScreenUtil().setWidth(17)),
                                  child: Text(models[index - 1].nick_name,
//                                      color:rgba(89,102,136,1);
                                      style: TextStyle(fontSize: 14.0,
                                          color: new Color(0xFF596688)),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                              ),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(22),
                                          left: ScreenUtil().setWidth(17),
                                          right: ScreenUtil().setWidth(80)),
                                      child: Text(
                                          models[index - 1].commodity_content,
                                          style: TextStyle(fontSize: 13.0,),
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,),
                                      ),
                                  ),
                              ),
                        ],),
                        ),
                    ),
              ],),
              ),
          //第二部分 图片列表girdview
          Container(
              height: girdHeight,
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(141),
                      top: ScreenUtil().setHeight(0),
                      right: 22.0),
                  child: GridView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Center(child: Image.file(
                            new File(listPath[index]), width: gridItemPicWidth,
                            height: gridItemPicHeight,
                            fit: BoxFit.cover,),);
                      },
                      itemCount: girdCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount),
                      scrollDirection: Axis.vertical,
                      physics: new NeverScrollableScrollPhysics(), //禁止滑动
                      ),
                  ),
              ),
          //时间 部分
          Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(156),
                  top: ScreenUtil().setHeight(52),
                  right: 2.0),
              child: Row(children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        child: Text(releaseDate,
                            style: TextStyle(
                                fontSize: 11.0, color: Colors.grey),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,),
                        ),
                    ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        width: ScreenUtil().setWidth(400),
//                        color: Colors.orangeAccent,
                        margin: EdgeInsets.only(top: 0.0, left: 10.0),
                        child: Row(children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  (shareDate.isEmpty || shareDate == null)
                                      ? ''
                                      : '$shareDate分享过',
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.grey),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                          Expanded(
                              child: Text(''),
                              ),
//                          Align(
//                              alignment: Alignment.topRight,
//                              child: GestureDetector(
//                                  onTap: () {},
//                                  child: Container(
//                                      margin: EdgeInsets.only(
//                                          right: ScreenUtil().setWidth(99)),
//                                      child: Row(children: <Widget>[
//                                        GestureDetector(
//                                            onTap: () {},
//                                            child: Image.asset(
//                                                'images/1xdown.png',
//                                                width: ScreenUtil().setWidth(
//                                                    56),
//                                                height: ScreenUtil().setHeight(
//                                                    56),),
//                                            ),
//                                        Text('下载', style: TextStyle(
//                                            fontSize: 11.0,
//                                            color: Colors.black),
//                                            textAlign: TextAlign.left,
//                                            overflow: TextOverflow.ellipsis,),
//                                      ],),
//                                      ),
//                                  )
//                          )
                        ],),
                        ),
                    ),
              ],),
              ),
          //分享按钮
          Padding(padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(148),
              top: ScreenUtil().setHeight(63),
              right: ScreenUtil().setWidth(152)),
              child: Row(children: <Widget>[
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          CommonUtils.onEvent(0);
                          share(models[index - 1]);
                        },
                        child: Container(
                            width: ScreenUtil().setWidth(842),
                            height: ScreenUtil().setHeight(140),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(6.0),
                                ),
                            child: Center(child: Text('我要分享',
                                style: TextStyle(color: Colors.white),),),
                            ),
                        ),
                    ),
              ],),
              ),
          //最后的分割线
          Padding(padding: EdgeInsets.only(
              left: 0.0,
              top: ScreenUtil().setHeight(61),
              right: 0.0,
              bottom: ScreenUtil().setHeight(61)),
              child: Container(
                  color: new Color(0xFFDFDFE2),
                  height: 1.0,
                  ),
              ),
        ],
            ),
        );
  }

  Widget _buildListHeader() {
    String url = 'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1165898706,1531320617&fm=11&gp=0.jpg';
    return Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(420),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/head.jpeg'), fit: BoxFit.fill)
        ),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(39),
                    bottom: ScreenUtil().setHeight(33)),
                child: Column(children: <Widget>[
                  ClipOval(
                      child: Image.network(
                          url,
                          width: ScreenUtil().setWidth(230),
                          height: ScreenUtil().setHeight(230),
                          fit: BoxFit.cover,),
                      ),
                  Text('小微', style: TextStyle(color: Colors.white),),
                ],
                    mainAxisAlignment: MainAxisAlignment.end,),
                ),
            ),
        );
  }

  /*分享到微信*/
  void share(HomeListModel model) {
    String url = 'http://f.hiphotos.baidu.com/image/pic/item/d439b6003af33a8724e4b645cb5c10385243b5e0.jpg';
    String imgUrl = model.listUrls[0];
    String shareUrl = model.listUrls[0];
    String time = model.time;
    print('imageUrl -- $imgUrl');
    String content = model.commodity_content;
    if (imgUrl != null && shareUrl != null) {
//        Umeng.wXShareWeb(url, url, '绘图故事之我妈妈');
//      Umeng.wXShareWebDescr(imgUrl,imgUrl,'微商相册',content);
//      Umeng.wXShareImage(url);
      Clipboard.setData(new ClipboardData(text: content));
      try{
        Umeng.wXShareImage(imgUrl).then((re){
          print('----shareResult----$re');
        });
        print("***********");
      }catch (e){
        print('----shareResult----${e.toString()}');
      }
//      Umeng.wXShareImageText(content, imgUrl, shareUrl).then((result) {
//        print('----shareResult----$result');
//      });
      DbHelper.getInstance().openDataBase(DbHelper.tableName).then((path) {
        DbHelper.getInstance().upData(time, TimeUtils.getNowTime());
      });
//      Umeng.wXShareWebDescr(url,url,'111','测试测试测试测试');
//      Umeng.wXShareText(content);
    }
  }


}