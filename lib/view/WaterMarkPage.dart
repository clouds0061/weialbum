import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wei_album/view/CustomImage.dart';
import 'dart:ui' as ui;

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class WaterMarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WaterMarkPageState();
}


class WaterMarkPageState extends State<WaterMarkPage> {

  bool showImage = false;
  ui.Image image;
  CustomImage customImage;
  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: '',
        home: Scaffold(
            appBar: AppBar(title: Text('测试'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back), onPressed: () {
                  try {
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                },),),
            body: buildLayout(),
            ),
        );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }


  ByteData imgBytes;

  Widget buildLayout() {
    if (showImage)
      return Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(children: <Widget>[
            Expanded(
                child:
//                Center(child: Image.memory(
//                    new Uint8List.view(imgBytes.buffer),
//                    width: 555.0,
//                    height: 555.0,
//                    ),),
                RepaintBoundary(
                    key: globalKey,
                    child:
                    CustomPaint(
                        painter: customImage,
                        size: Size(400.0, 600.0),
                        ),
                    )
//                CustomPaint(
//                    painter: customImage,
//                    size: Size(400.0,600.0),
//                    )
            ),
            Container(
                width: double.infinity,
                height: 80.0,
                color: Colors.green,
                child: GestureDetector(
                    onTap: () {
                      try {
                        screenShot();
//                        customImage.save();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Center(child: Text('保存'),),
                    ),
                ),
          ],),);
    else
      return Container(
          child: Center(child: CircularProgressIndicator(),),
          );
  }

  Future getImage() async {
//    Uint8List list;
    await ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      print('---setp 1--- $file');
      file.readAsBytes().then((list) {
        print('---setp 2--- ${list.length}');
        ui.decodeImageFromList(list, (img) {
          print('---setp 3--- ${img.toString()}');
          image = img;
          showImage = true;
          customImage = new CustomImage(image, BoxFit.fill);
          setState(() {});
//          generateImage;
        });
      });
    });
  }

  void generateImage(Canvas canvas) async {
    var kCanvasSize = 550.0;
    final recorder = new ui.PictureRecorder();
    final canvas = new Canvas(
        recorder,
        new Rect.fromPoints(
            new Offset(0.0, 0.0), new Offset(kCanvasSize, kCanvasSize)));


    final paint = new Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    _paintImage(
        image, new Rect.fromLTRB(0.0, 0.0, kCanvasSize, kCanvasSize), canvas,
        paint, BoxFit.fill);

    final picture = recorder.endRecording();
    final img = picture.toImage(200, 200);
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    setState(() {
      showImage = true;
      imgBytes = byteData;
    });
  }

  void _paintImage(ui.Image image, Rect outputRect, Canvas canvas, Paint paint,
      BoxFit fit) {
    print('1');
    final Size imageSize = new Size(
        image.width.toDouble(), image.height.toDouble());
    print('2');
    final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
    print('3');
    final Rect inputSubrect = Alignment.center.inscribe(
        sizes.source, Offset.zero & imageSize);
    print('4');
    final Rect outputSubrect = Alignment.center.inscribe(
        sizes.destination, outputRect);
    print('5');
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
    image.toByteData(format: ui.ImageByteFormat.png).then((data) {
      print('6  -- ${data.lengthInBytes}');
      _saveImage(null, data);
    });
  }

  void _saveImage(PictureRecorder recorder, var png) async {
    try {
//      final picture = recorder.endRecording();
//      final img = picture.toImage(400, 800);
//      var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = png.buffer.asUint8List();
      print('----step 4---- : ${pngBytes.length}');
      Directory d = new Directory('${(await getTemporaryDirectory()) //新建 图书目录
          .path}/img');
      if (!(await d.exists())) d.create();
      File file_new = new File('${(await getTemporaryDirectory())
          .path}/img/images.png');
//    File file_new = new File(file.path);
      if (await file_new.exists()) file_new.delete(recursive: true);
      file_new.create(recursive: true);
      file_new.writeAsBytes(pngBytes).then((file) {
        print('file - : $file');
        return file;
      });
    } catch (e) {
      print('----error----$e');
    }
  }

  void screenShot() {
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
    print('pngBytes : ${pngBytes.length}');
    return pngBytes;
  }

  Future writeToFile(Uint8List list) async {
    Directory d = new Directory('${(await getTemporaryDirectory()) //新建 图书目录
        .path}/img');
    if (!(await d.exists())) d.create();
    File file_new = new File('${(await getTemporaryDirectory())
        .path}/img/images1.png');
    if (await file_new.exists()) file_new.delete(recursive: true);
    file_new.create(recursive: true);
    file_new.writeAsBytes(list).then((file) {
      print('file - : $file');
      return file;
    });
  }
}