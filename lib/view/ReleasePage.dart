import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wei_album/utils/DbHelper.dart';
import 'package:wei_album/utils/TimeUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wei_album/view/AddWaterMarkPage.dart';
import 'package:wei_album/view/WaterMarkPage.dart';

//发布页面
class ReleasePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReleasePageState();
}

class ReleasePageState extends State<ReleasePage> {
  FocusNode focusNode = new FocusNode();
  TextEditingController controller = new TextEditingController();
  int _radio_value = 1;
  bool showPop = true;
  List<String> filePaths = new List();
  List<File> files = new List();
  BuildContext con;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    con = context;
    // TODO: implement build
    return MaterialApp(
        title: '',
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                    '发布图文', style: TextStyle(color: new Color(0xFF020202)),),
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('images/1xback.png'),
                    ),
                actions: <Widget>[
                  Center(
                      child: GestureDetector(
                      //点击分享出去
                          onTap: () {},
                          child: Text('分享', style: TextStyle(
                              fontSize: 15.5, color: Colors.green),),
                          ),
                      ),
                ],
                ),
            body: Stack(children: <Widget>[
              buildLayout(),
              Offstage(
                  offstage: showPop,
                  child: Align(
                      alignment: Alignment.center,
                      child: buildPop(),
                      ),
                  ),
            ],),
            resizeToAvoidBottomPadding: false,
            ),
        );
  }

  Widget buildLayout() {
    return Container(
        padding: EdgeInsets.only(left: 0.0, right: 0.0),
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              focusNode.unfocus();
              String input = controller.text;
              print('----submit---- $input');
            },
            child: Column(children: <Widget>[
              buildTextField(), //文字编辑部分
              buildPicGridView(), //图片
              buildAddText(), //添加水印
              buildBrowsePermissions(), //权限部分
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: buildSaveButton(),
                      ),
                  ),
            ],),
            ),
        );
  }

  //文字输入部分
  Widget buildTextField() {
    return Container(
        margin: EdgeInsets.only(top: 10.0,
            left: ScreenUtil().setWidth(57),
            right: ScreenUtil().setWidth(57)),
        height: 70.0,
        child: TextField(
            controller: controller,
//            onChanged: (input){
//                print('----input---- $input');
//            },
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

  //相册添加部分
  Widget buildPicGridView() {
    int count = files.length + 1;
    if (count > 6) count = 6;
    List<Widget> widgets = new List();
    for (int i = 0; i < count; i++) {
      widgets.add(buildItem(con, i));
    }
    return Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(70),
            left: ScreenUtil().setWidth(57),
            right: ScreenUtil().setWidth(57)),
        width: double.infinity,
        height: ScreenUtil().setHeight(765),
        child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            children: widgets,
            crossAxisCount: 3,
            ),
//        child: GridView.builder(
//            physics: NeverScrollableScrollPhysics(),
//            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                crossAxisCount: 3),
//            itemCount: count,
//            itemBuilder: buildItem,
//            ),
        );
  }

  Widget buildItem(BuildContext context, int index) {
    Image image2 = Image.asset('images/1xdelete.png',
        width: ScreenUtil().setWidth(77),
        height: ScreenUtil().setHeight(77),);
    bool flag = false;
    if (index == files.length && files.length < 6) flag = true;
    return GridTile(
        header: flag == true ? null : Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                onTap: () {
                  deletePic(index);
                },
                child: image2,
                )),
        child: flag == true ? Center( //添加图片按钮
            child: Container(
                child: GestureDetector(
                    onTap: () {
                      setImage();
                    },
                    child: Stack(children: <Widget>[
                      Center(child: Image.asset('images/add_default.png',
                          width: ScreenUtil().setWidth(311),
                          height: ScreenUtil().setHeight(311),
                          fit: BoxFit.cover,),),
                    ],),
                    ),
                ),
            ) : buildPicItem(index),
        );
    if (index == files.length && files.length < 6) {
      return Center( //添加图片按钮
          child: Container(
              child: GestureDetector(
                  onTap: () {
                    setImage();
                  },
                  child: Stack(children: <Widget>[
                    Center(child: Image.asset('images/add_default.png',
                        width: ScreenUtil().setWidth(311),
                        height: ScreenUtil().setHeight(311),
                        fit: BoxFit.cover,),),
                  ],),
                  ),
              ),
          );
    } else
      return GridTile(
          header: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () {
                    deletePic(index);
                  },
                  child: image2,
                  )),
          child: buildPicItem(index),
          );
  }


  //相册item
  Widget buildPicItem(int index) {
    File file = files[index];
    Image image1 = Image.file(file, width: ScreenUtil().setWidth(311),
        height: ScreenUtil().setHeight(311),
        fit: BoxFit.cover,);
//    Image image1 = Image.asset('images/head.jpeg');
    Image image2 = Image.asset('images/1xdelete.png',
        width: ScreenUtil().setWidth(77),
        height: ScreenUtil().setHeight(77),);
    return Center(child: FadeInImage(
        image: FileImage(files[index]),
        placeholder: AssetImage('images/default.jpeg'),
        fit: BoxFit.cover,
        width: ScreenUtil().setWidth(321),
        height: ScreenUtil().setHeight(321),
        ),);
    return Stack(children: <Widget>[
      image1,
//          Center(child: image1,),
      Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () {
                deletePic(index);
              },
              child: image2,
              ),
          ),
    ],
        alignment: AlignmentDirectional.center,);
  }

  //添加水印
  Widget buildAddText() {
    return Container(
        margin: EdgeInsets.only(top: 5.0),
        width: double.infinity,
//        height: 80.0,
        child: GestureDetector(
            onTap: () {
              addText();
            },
            child: Column(children: <Widget>[
              Container(
                  width: double.infinity,
                  color: new Color(0xFFDFDFE2),
                  height: 1.0,
                  ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(57),
                      bottom: ScreenUtil().setHeight(60),
                      left: ScreenUtil().setWidth(57),
                      right: ScreenUtil().setWidth(57)),
                  child: Row(children: <Widget>[
                    Text('添加水印'),
                    Expanded(
                        child: Text(''),
                        ),
                    Image.asset('images/go_forward.png'),
                  ],),
                  ),
              Container(
                  width: double.infinity,
                  color: new Color(0xFFDFDFE2),
                  height: 1.0,
                  ),
            ],),
            ),
        );
  }

  //添加水印 具体操作
  addText() {
    Navigator.of(context).push(new MaterialPageRoute(builder:(BuildContext context){
//        return AddWaterMarkPage(addTextCallBack,files[0]);
          return WaterMarkPage();
    }));
//    Image image = Image.file(files[0]);
//    File file = files[0];
//    print('******image****** $image');
//    print('******file****** $file');
//    ImageUtils.getInstance().init(image, file).then((_) {
//      print('result: $_');
//      setState(() {
//      });
//    });
  }

  void addTextCallBack(File file){
      print('path : ${file}');
      setState(() {
          files.removeAt(0);
          files.add(file);
      });
  }

  //设置浏览权限
  Widget buildBrowsePermissions() {
    Color color = new Color(0xFF777777);
    return Container(
//        color: Colors.blue,
        margin: EdgeInsets.only(top: 5.0),
        width: double.infinity,
        child: Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Row(children: <Widget>[
                Radio(
                    value: 1,
                    groupValue: _radio_value,
                    onChanged: (change) {
                      setState(() {
                        _radio_value = 1;
                      });
                    },
                    ),
                Text('公开', style: TextStyle(color: color),),
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
                      });
                    },
                    ),
                Text('仅自己可见', style: TextStyle(color: color),),
              ],),
              ),
        ],
            crossAxisAlignment: CrossAxisAlignment.start,
            ),
        );
  }

  //保存按钮
  Widget buildSaveButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            onTap: () {
              save();
            },
            child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(155),
                color: Colors.green,
                child: Center(child: Text('保存'),),
                ),
            ),
        );
  }

  //设置图片
  setImage() {
    showPop = false;
    setState(() {});
  }

  //弹窗
  Widget buildPop() {
    return Stack(children: <Widget>[
      GestureDetector(
          onTap: () {
            showPop = true;
            setState(() {});
          },
          child: Container(
              color: new Color(0x40777777),
              width: double.infinity,
              height: double.infinity,
              ),
          ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              width: double.infinity,
              height: ScreenUtil().setHeight(495),
              child: Column(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: GestureDetector(onTap: () {
                      popOnClick(1);
                    },
                        child: Align(alignment: Alignment.bottomCenter,
                            child: Container(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text('从手机相册选择',
                                    style: TextStyle(fontSize: 16.0,
                                        color: new Color(0xFF020202)),),)),),
                    ),
                Container(margin: EdgeInsets.only(top: 5.0),
                    width: double.infinity,
                    height: 1.0,
                    color: new Color(0xFFDFDFE2),),
                Expanded(
                    flex: 1,
                    child: GestureDetector(onTap: () {
                      popOnClick(2);
                    },
                        child: Align(alignment: Alignment.bottomCenter,
                            child: Container(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                    '拍照',
                                    style: TextStyle(fontSize: 16.0,
                                        color: new Color(0xFF020202)),),)),),
                    ),
                Container(margin: EdgeInsets.only(top: 5.0),
                    width: double.infinity,
                    height: 1.0,
                    color: new Color(0xFFDFDFE2),),
                Expanded(
                    flex: 1,
                    child: GestureDetector(onTap: () {
                      popOnClick(3);
                    },
                        child: Align(alignment: Alignment.center,
                            child: Container(
                                padding: EdgeInsets.only(bottom: 0.0),
                                child: Text(
                                    '取消',
                                    style: TextStyle(fontSize: 16.0,
                                        color: Colors.red),),)),),
                    ),
              ],),
              ),
          )
    ],);
  }


  popOnClick(int index) async {
    switch (index) {
      case 1:
        print('点击了 从相册选择  ');
        File image = await ImagePicker.pickImage(source: ImageSource.gallery)
            .then((file) {
          String path = file.path;
          filePaths.add(path);
          print('---fielPath---$path');
          files.add(file);
          showPop = true;
          setState(() {});
        });
        print('---image---${image.toString()}');
        break;
      case 2:
        print('点击了 拍照  ');
        var image = ImagePicker.pickImage(source: ImageSource.camera).then((
            file) {
          String path = file.path;
          filePaths.add(path);
          print('---fielPath---$path');
          files.add(file);
          showPop = true;
          setState(() {});
        });
        break;
      case 3:
        print('点击了 取消  ');
        setState(() {
          showPop = true;
        });
        break;
    }
  }

  /*点击删除图片*/
  void deletePic(int index) {
    files.removeAt(index);
    setState(() {});
  }

  void save() {
    String headUrl = 'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1165898706,1531320617&fm=11&gp=0.jpg';
    String nick_name = '小微';
    String content = controller.text;
    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i < files.length; i++) {
      buffer.write('${files[i].path};');
    }
    print('savePath -- : ${buffer.toString()}');
    String img_path = buffer.toString();
    String time = TimeUtils.getNowTime();
    print('A---time--- $time');
    print('A---img_path--- $img_path');
    print('A---content--- $content');
    DbHelper.getInstance().openDataBase(DbHelper.tableName).then((path) {
      DbHelper.getInstance().insert2(
          '"$headUrl"', '"$nick_name"', '"$content"', '"$img_path"', '"$time"',
          '""');
      Navigator.pop(context);
    });
  }
}