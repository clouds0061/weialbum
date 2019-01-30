import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:wei_album/utils/ColorUtils.dart';
import 'dart:math';

import 'package:wei_album/utils/TimeUtils.dart';

/*添加水印*/
class AddWaterMarkPage extends StatefulWidget {
  Function function;
  File file;

  @override
  State<StatefulWidget> createState() => AddWaterMarkPageState(file, function);

  AddWaterMarkPage(this.function, this.file);


}


class AddWaterMarkPageState extends State<AddWaterMarkPage> {
  File file;
  Function function;
  GlobalKey globalKey = new GlobalKey();
  Color textColor = Colors.white;
  List<Color> colorList = new List();
  double textSize = 14.5;
  int textId = 1;

  bool notShowAdd = false; //截屏时  不显示添加水印部分
  bool notShowDelete = false; //截屏时 不限是删除按钮
  double opacity = 1.0; //1.0不透明  0.0透明
  String saveString = '完成';


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    notShowAdd = false;
    notShowDelete = false;
    opacity = 1.0;
    textId = 1;
    textSize = 14.5;
    textColor = Colors.white;
    saveString = '完成';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colorList.addAll(ColorUtils.getColorList());
    saveString = '完成';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.instance = new ScreenUtil(width: 1242, height: 2208)
      ..init(context);
    return MaterialApp(
        title: '',
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                    '添加水印', style: TextStyle(color: new Color(0xFF020202)),),
                centerTitle: true,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
//                        color: Colors.orangeAccent,
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(40),
                        child: Image.asset('images/1xback.png'),
                        ),
                    ),
                actions: <Widget>[
                  Container(
//                      color: Colors.orangeAccent,
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setHeight(40),
                      child: Center(
                          child: GestureDetector(
                          //点击分享出去
                              onTap: () {
                                print('---');
                                save();
                              },
                              child: Text(saveString, style: TextStyle(
                                  fontSize: 15.5,
                                  color: Color(ColorUtils.colorFinishGreen)),),
                              ),
                          ),
                      ),
                ],),
            body: buildHome(),
            resizeToAvoidBottomPadding: false,
            ));
  }

  Future getPic() async {
    _capturePng().then((list) {
      writeToFile(list).then((file) {
        print('file -- : $file');
//        function(file);
//        Navigator.pop(context);
      });
    });
  }

  // 截图boundary，并且返回图片的二进制数据。
  Future<Uint8List> _capturePng() async {
//    RenderRepaintBoundary boundary = globalKey.currentContext
//        .findRenderObject();
    RenderRepaintBoundary boundary = globalKey.currentContext
        .findRenderObject();
    ui.Image image = await boundary.toImage();
    // 注意：png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    print('pngBytes : pngBytes');
    return pngBytes;
  }

  Future writeToFile(Uint8List list) async {
    Directory d = new Directory('${(await getTemporaryDirectory()) //新建 图书目录
        .path}/img');
    String timeNow = TimeUtils.getNowTimeyyyy_MM_dd_HH_mm_ss();
    if (!(await d.exists())) d.create();
    File file_new = new File('${(await getTemporaryDirectory())
        .path}/img/images$timeNow.png');
//    File file_new = new File(file.path);
    if (await file_new.exists()) file_new.delete(recursive: true);
    file_new.create(recursive: true);
    file_new.writeAsBytes(list).then((file) {
      print('file - : $file');
      function(file);
      Navigator.pop(context);
//      Navigator.of(context).pop('');
      return file;
    });
  }

  AddWaterMarkPageState(this.file, this.function);


  bool showTextTopLeft = false;
  bool showTextBottomLeft = false;
  bool showTextTopRight = false;
  bool showTextBottomRight = false;
  bool showTextCenter = false;
  var textTopLeft = '请您添加水印';
  var textBottomLeft = '请您添加水印';
  var textTopRight = '请您添加水印';
  var textBottomRight = '请您添加水印';
  var textCenter = '请您添加水印';

  //添加水印部分
  Widget addWaterImage() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: FileImage(file), fit: BoxFit.fill)
        ),
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: buildWaterMarkTopLeft(showTextTopLeft, textTopLeft),
              ), //左上
          Align(
              alignment: Alignment.bottomLeft,
              child: buildWaterMarkBottomLeft(
                  showTextBottomLeft, textBottomLeft),
              ), //左下
          Align(
              alignment: Alignment.topRight,
              child: buildWaterMarkTopRight(showTextTopRight, textTopRight),
              ), //右上
          Align(
              alignment: Alignment.bottomRight,
              child: buildWaterMarkBottomRight(
                  showTextBottomRight, textBottomRight),
              ), //右下
          Align(
              alignment: Alignment.center,
              child: buildWaterMarkCenter(showTextCenter, textCenter),
              ), //中间
//          Image.file(file, fit: BoxFit.fill,alignment: Alignment.center,),
        ],),
        );
  }

  TextEditingController controller = new TextEditingController();
  FocusNode focusNode = new FocusNode();

  //文字编辑部分
  Widget addText() {
    return Container(
        margin: EdgeInsets.only(top: 0.0,
            left: ScreenUtil().setWidth(57),
            right: ScreenUtil().setWidth(57)),
        height: ScreenUtil().setHeight(127),
        child: TextField(
            controller: controller,
            onChanged: (input) {
              setState(() {
                switch (textId) {
                  case 1:
                    if (showTextTopLeft) setState(() {
                      textTopLeft = controller.text;
                    });
                    break;
                  case 2:
                    if (showTextBottomLeft) setState(() {
                      textBottomLeft = controller.text;
                    });
                    break;
                  case 3:
                    if (showTextTopRight) setState(() {
                      textTopRight = controller.text;
                    });
                    break;
                  case 4:
                    if (showTextBottomRight) setState(() {
                      textBottomRight = controller.text;
                    });
                    break;
                  case 5:
                    if (showTextCenter) setState(() {
                      textCenter = controller.text;
                    });
                    break;
                }
              });
            },
            focusNode: focusNode,
            maxLines: 4,
//            maxLength: 120,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '输入介绍',
//                labelText: '这一刻的想法',
                ),
            ),
        );
  }

  //选择文字颜色
  Widget choseTextColor() {
    if (colorList.length == 0 || colorList.isEmpty) {
      colorList.clear();
      colorList.add(Color(0xFFD8D8D9)); //白色
      colorList.add(Color(0xFF000000));
      colorList.add(Color(0xFFFF3737));
      colorList.add(Color(0xFFFF5400));
      colorList.add(Color(0xFF45BF1A));
      colorList.add(Color(0xFF2462FF));
      colorList.add(Color(0xFF2462FF));
      colorList.add(Color(0xFFDD24FF));
      colorList.add(Color(0xFFFF3BAE));
    }
    return Container(
        margin: EdgeInsets.only(top: 0.0),
        width: double.infinity,
        height: ScreenUtil().setHeight(100),
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(57)),
              child: Align(alignment: Alignment.centerLeft,
                  child: Text('文字颜色', style: TextStyle(
                      color: Color(ColorUtils.colorTextBlackFF020202),
                      fontSize: 15.0),),),
              ),
          Container(
//              color: Colors.orangeAccent,
              width: double.infinity,
              height: ScreenUtil().setHeight(170),
              child: ListView.builder(
                  itemBuilder: buildGrid,
                  itemCount: colorList.length,
//                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  ),
              ),
        ],)
    );
  }

  int _radio_value = 1;

  //选择文字大小
  Widget choseTextSize() {
    return Container(
//        color: Colors.blue,
        margin: EdgeInsets.only(top: 5.0),
        width: double.infinity,
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(57)),
              child: Align(alignment: Alignment.centerLeft,
                  child: Text('文字大小', style: TextStyle(
                      color: Color(ColorUtils.colorTextBlackFF020202),
                      fontSize: 15.0),),),
              ),
          Row(children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(children: <Widget>[
                  Radio(
                      value: 1,
                      groupValue: _radio_value,
                      onChanged: (change) {
                        setState(() {
                          _radio_value = 1;
                          textSize = 11.0;
                        });
                      },
                      ),
                  Text('小', style: TextStyle(color: Colors.grey),),
                ],),
                ),
            Expanded(
                flex: 1,
                child: Row(children: <Widget>[
                  Radio(
                      value: 2,
                      groupValue: _radio_value,
                      onChanged: (change) {
                        setState(() {
                          _radio_value = 2;
                          textSize = 14.5;
                        });
                      },
                      ),
                  Text('中', style: TextStyle(color: Colors.grey),),
                ],),
                ),
            Expanded(
                flex: 1,
                child: Row(children: <Widget>[
                  Radio(
                      value: 3,
                      groupValue: _radio_value,
                      onChanged: (change) {
                        setState(() {
                          _radio_value = 3;
                          textSize = 18.0;
                        });
                      },
                      ),
                  Text('大', style: TextStyle(color: Colors.grey),),
                ],),
                ),
          ],
              crossAxisAlignment: CrossAxisAlignment.start,
              ),
        ],)

    );
  }


  Widget buildHome() {
//    return Container();
    return GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(children: <Widget>[
              Container(
                  child: RepaintBoundary(
                      key: globalKey,
                      child: Stack(children: <Widget>[
                        Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(1240),
                            child: addWaterImage(),
                            ),
                      ],),
                      ),
                  ),
              addText(), //添加文字
              Container(width: double.infinity,
                  height: 0.8,
                  color: Color(ColorUtils.colorDividingLineGrey),
                  margin: EdgeInsets.only(top: 4.0),),
              choseTextSize(), //选择文字大小
              Expanded(child: choseTextColor(),), //选择文字颜色
            ],),
            ),
        );
  }

  //保存 添加水印后的图片
  void save() {
    if (saveString == '完成') {
      setState(() {
//      notShowDelete = true;
//      notShowAdd = true;
        opacity = 0.0;
        saveString = '保存';
      });
    } else {
      getPic();
    }
//    getPic();
  }

  //未点击前现实添加水印   点击后显示添加的文字
  Widget buildWaterMarkCenter(bool show, String text) {
    if (text == '' || text.isEmpty || text == null) text = '请您添加水印';
    if (showTextCenter) {
      return Container(
          width: ScreenUtil().setWidth(557),
          height: ScreenUtil().setHeight(177),
          child: Column(children: <Widget>[
            Opacity(
                opacity: opacity,
                child: Container(
                    height: ScreenUtil().setHeight(67),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showTextCenter = false;
                                controller.clear();
                              });
                            },
                            child: Image.asset('images/1xdelete.png'),
                            ),
                        ),
                    ),
                ),
            Container(
                height: ScreenUtil().setHeight(110),
                child: GestureDetector(
                    onTap: () {
                      if (textId != 5) controller.clear();
                      textId = 5;
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('$text', style: TextStyle(
                            color: textColor, fontSize: textSize),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                        ),
                    ),
                ),
          ],),
          );
    } else {
      return GestureDetector(
          onTap: () {
            print('$text');
            setState(() {
              textId = 5;
              showTextCenter = true;
              controller.clear();
            });
          },
          child: Opacity(
              opacity: opacity,
              child: Container(
                  width: ScreenUtil().setWidth(357),
                  height: ScreenUtil().setHeight(117),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          color: Color(ColorUtils.colorButtonGreen)),
                      ),
                  child: Center(child: Row(children: <Widget>[
                    Image.asset('images/1xadd.png'),
                    Text('添加水印', style: TextStyle(
                        color: Color(ColorUtils.colorButtonGreen)),),
                  ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,),),
                  ),
              ),
          );
    }
  }

  //未点击前现实添加水印   点击后显示添加的文字
  Widget buildWaterMarkBottomRight(bool show, String text) {
    if (text == '' || text.isEmpty || text == null) text = '请您添加水印';
    if (showTextBottomRight) {
      return Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(50),
              bottom: ScreenUtil().setHeight(50)),
          width: ScreenUtil().setWidth(557),
          height: ScreenUtil().setHeight(177),
          child: Column(children: <Widget>[
            Opacity(
                opacity: opacity,
                child: Container(
                    height: ScreenUtil().setHeight(67),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showTextBottomRight = false;
                                controller.clear();
                              });
                            },
                            child: Image.asset('images/1xdelete.png'),
                            ),
                        ),
                    ),
                ),
            Container(
                height: ScreenUtil().setHeight(110),
                child: GestureDetector(
                    onTap: () {
                      if (textId != 4) controller.clear();
                      controller.clear();
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('$text', style: TextStyle(
                            color: textColor, fontSize: textSize),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                        ),
                    ),
                ),
          ],),
          );
    } else {
      return GestureDetector(
          onTap: () {
            print('$text');
            setState(() {
              textId = 4;
              showTextBottomRight = true;
              controller.clear();
            });
          },
          child: Opacity(
              opacity: opacity,
              child: Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(50),
                      bottom: ScreenUtil().setHeight(50)),
                  width: ScreenUtil().setWidth(357),
                  height: ScreenUtil().setHeight(117),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          color: Color(ColorUtils.colorButtonGreen)),
                      ),
                  child: Center(child: Row(children: <Widget>[
                    Image.asset('images/1xadd.png'),
                    Text('添加水印', style: TextStyle(
                        color: Color(ColorUtils.colorButtonGreen)),),
                  ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,),),
                  ),
              ),
          );
    }
  }

  //未点击前现实添加水印   点击后显示添加的文字
  Widget buildWaterMarkTopRight(bool show, String text) {
    if (text == '' || text.isEmpty || text == null) text = '请您添加水印';
    if (showTextTopRight) {
      return Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(50),
              top: ScreenUtil().setHeight(50)),
          width: ScreenUtil().setWidth(557),
          height: ScreenUtil().setHeight(177),
          child: Column(children: <Widget>[
            Opacity(
                opacity: opacity,
                child: Container(
                    height: ScreenUtil().setHeight(67),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showTextTopRight = false;
                                controller.clear();
                              });
                            },
                            child: Image.asset('images/1xdelete.png'),
                            ),
                        ),
                    ),
                ),
            Container(
                height: ScreenUtil().setHeight(110),
                child: GestureDetector(
                    onTap: () {
                      if (textId != 3) controller.clear();
                      controller.clear();
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('$text', style: TextStyle(
                            color: textColor, fontSize: textSize),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                        ),
                    ),
                ),
          ],),
          );
    } else {
      return GestureDetector(
          onTap: () {
            print('$text');
            setState(() {
              textId = 3;
              showTextTopRight = true;
              controller.clear();
            });
          },
          child: Opacity(
              opacity: opacity,
              child: Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(50),
                      top: ScreenUtil().setHeight(50)),
                  width: ScreenUtil().setWidth(357),
                  height: ScreenUtil().setHeight(117),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          color: Color(ColorUtils.colorButtonGreen)),
                      ),
                  child: Center(child: Row(children: <Widget>[
                    Image.asset('images/1xadd.png'),
                    Text('添加水印', style: TextStyle(
                        color: Color(ColorUtils.colorButtonGreen)),),
                  ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,),),
                  ),
              ),
          );
    }
  }

  //未点击前现实添加水印   点击后显示添加的文字
  Widget buildWaterMarkBottomLeft(bool show, String text) {
    if (text == '' || text.isEmpty || text == null) text = '请您添加水印';
    if (showTextBottomLeft) {
      return Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(50),
              bottom: ScreenUtil().setHeight(50)),
          width: ScreenUtil().setWidth(557),
          height: ScreenUtil().setHeight(177),
          child: Column(children: <Widget>[
            Opacity(
                opacity: opacity,
                child: Container(
                    height: ScreenUtil().setHeight(67),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.clear();
                                showTextBottomLeft = false;
                              });
                            },
                            child: Image.asset('images/1xdelete.png'),
                            ),
                        ),
                    ),
                ),
            Container(
                height: ScreenUtil().setHeight(110),
                child: GestureDetector(
                    onTap: () {
                      if (textId != 2) controller.clear();
                      controller.clear();
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('$text', style: TextStyle(
                            color: textColor, fontSize: textSize),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                        ),
                    ),
                ),
          ],),
          );
    } else {
      return GestureDetector(
          onTap: () {
            print('$text');
            setState(() {
              textId = 2;
              showTextBottomLeft = true;
              controller.clear();
            });
          },
          child: Opacity(
              opacity: opacity,
              child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(50),
                      bottom: ScreenUtil().setHeight(50)),
                  width: ScreenUtil().setWidth(357),
                  height: ScreenUtil().setHeight(117),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          color: Color(ColorUtils.colorButtonGreen)),
                      ),
                  child: Center(child: Row(children: <Widget>[
                    Image.asset('images/1xadd.png'),
                    Text('添加水印', style: TextStyle(
                        color: Color(ColorUtils.colorButtonGreen)),),
                  ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,),),
                  ),
              ),
          );
    }
  }

  //未点击前现实添加水印   点击后显示添加的文字
  Widget buildWaterMarkTopLeft(bool show, String text) {
    if (text == '' || text.isEmpty || text == null) text = '请您添加水印';
    if (showTextTopLeft) {
      return Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(50), top: ScreenUtil().setHeight(50)),
          width: ScreenUtil().setWidth(557),
          height: ScreenUtil().setHeight(177),
          child: Column(children: <Widget>[
            Opacity(
                opacity: opacity,
                child: Container(
                    height: ScreenUtil().setHeight(67),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showTextTopLeft = false;
                                controller.clear();
                              });
                            },
                            child: Image.asset('images/1xdelete.png'),
                            ),
                        ),
                    ),
                ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    if (textId != 1) controller.clear();
                    controller.clear();
                  });
                },
                child: Container(
                    height: ScreenUtil().setHeight(110),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('$text', style: TextStyle(
                            color: textColor, fontSize: textSize),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,),
                        ),
                    ),
                ),
          ],),
          );
    } else {
      return GestureDetector(
          onTap: () {
            print('$text');
            setState(() {
              textId = 1;
              showTextTopLeft = true;
              controller.clear();
            });
          },
          child: Opacity(
              opacity: opacity,
              child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(50),
                      top: ScreenUtil().setHeight(50)),
                  width: ScreenUtil().setWidth(357),
                  height: ScreenUtil().setHeight(117),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          color: Color(ColorUtils.colorButtonGreen)),
                      ),
                  child: Center(child: Row(children: <Widget>[
                    Image.asset('images/1xadd.png'),
                    Text('添加水印', style: TextStyle(
                        color: Color(ColorUtils.colorButtonGreen)),),
                  ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,),),
                  ),
              ),
          );
    }
  }

  Widget buildGrid(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            textColor = colorList[index];
          });
        },
        child: Container(
            width: ScreenUtil().setWidth(138),
            height: ScreenUtil().setHeight(138),
            color: Colors.white,
            child: Center(child: Container(
                width: ScreenUtil().setWidth(77),
                height: ScreenUtil().setHeight(77),
                color: colorList[index]
            ),),
            ),
        );
  }
}
