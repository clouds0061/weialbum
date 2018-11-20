import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
        title: '',
        home: Column(children: <Widget>[
          Expanded(
              child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(children: <Widget>[
//                    Container(
//                        color: Colors.green,
//                        width: double.infinity,
//                        height: double.infinity,
//                        child: Image.file(file, fit: BoxFit.cover,),
//                        ),
                    Image.asset('images/1xdelete.png', width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,),
                    Center(child: Text('aaaaa'),),
                    Icon(Icons.add),
                    Align(alignment: Alignment.bottomCenter,child: Image.asset('images/pull.jpeg'),)
                  ],),
                  ),
              ),
          GestureDetector(
              onTap: () {
                getPic();
              },
              child: Container(
                  width: double.infinity,
                  height: 80.0,
                  color: Colors.green,
                  ),
              ),
        ],));
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
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
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
    if (!(await d.exists())) d.create();
    File file_new = new File('${(await getTemporaryDirectory())
        .path}/img/images1.png');
//    File file_new = new File(file.path);
    if (await file_new.exists()) file_new.delete(recursive: true);
    file_new.create(recursive: true);
    file_new.writeAsBytes(list).then((file) {
      print('file - : $file');
      function(file);
      Navigator.pop(context);
      return file;
    });
  }

  AddWaterMarkPageState(this.file, this.function);
}
