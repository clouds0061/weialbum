import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:wei_album/view/CustomImage.dart';

class MyImage extends StatefulWidget {

  ui.Image image;

  MyImage(this.image, {Key key}) :super(key: key);

  @override
  State<StatefulWidget> createState() => ImageState(image);
}

class ImageState extends State<MyImage> {
  ui.Image     image;

  ImageState(this.image);

  Uint8List uint8list;
  bool finish = false;

  ui.Image get getImage {
    var pictureRecorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(pictureRecorder);
//    SignaturePainter painter = new SignaturePainter(_points);
    CustomImage painter = new CustomImage(image, BoxFit.fill);

    var size = context.size;
    // if you pass a smaller size here, it cuts off the lines
    painter.paint(canvas, size);
    // if you use a smaller size for toImage, it also cuts off the lines - so I've
    // done that in here as well, as this is the only place it's easy to get the width & height.
    return pictureRecorder.endRecording().toImage(
        size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return finish == true ? Container(
        width: double.infinity,
        height: double.infinity,
        child:
//        Image.memory(uint8list),
          CustomPaint(
              painter: CustomImage(image,BoxFit.fill),
              size: Size(400.0,600.0),
          )
        ) : Container(
        child: CircularProgressIndicator(),
        );
  }

  getImages() async {
    try{
      await image.toByteData(format: ui.ImageByteFormat.png).then((data) {
        var list = data.buffer.asUint8List();
        setState(() {
          uint8list = list;
          finish = true;
        });
      });
    }catch (e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    finish = false;
    uint8list = null;
  }

}