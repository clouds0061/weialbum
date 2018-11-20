import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

class CustomImage extends CustomPainter {

  ui.Image image;
  BoxFit boxFit;
  PictureRecorder recorder;


  CustomImage(this.image, this.boxFit);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = new Paint();


//    final recorder = new ui.PictureRecorder();
//    recorder = PictureRecorder();
//    final ca = new Canvas(
//        recorder,
//        new Rect.fromPoints(
//            new Offset(0.0, 0.0), new Offset(size.width, size.height)));

//    paintImage(
//        image, new Rect.fromLTRB(0.0, 0.0, 400.0, 600.0), ca,
//        paint2, boxFit);
//    ca.drawCircle(new Offset(100.0,100.0),50.0,paint2);
//    ca.drawImage(image,new Offset(0.0,0.0),paint2);
    print('----step 5----${image}');

    Paint circle = new Paint();
    paint.color = Colors.green;
//    _saveImage(recorder);
    _paintImage(
        image, new Rect.fromLTRB(0.0, 0.0, size.width, size.height), canvas,
        paint, boxFit);
    canvas.drawCircle(new Offset(300.0,300.0),60.0,circle);
    drawText('测试测试', canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
  }

  void save() {
    _saveImage(recorder);
  }

  void _paintImage(ui.Image image, Rect outputRect, Canvas canvas, Paint paint,
      BoxFit fit) {
    final Size imageSize = new Size(
        image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
    final Rect inputSubrect = Alignment.center.inscribe(
        sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect = Alignment.center.inscribe(
        sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
  }

  void _saveImage(PictureRecorder recorder) async {
    try {
      final picture = recorder.endRecording();
      final img = picture.toImage(400, 800);
      var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
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

  void drawText(String s, Canvas canvas) {
    ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        fontSize: 14.5
    ));
    builder.pushStyle(ui.TextStyle(color: Colors.red));
    builder.addText(s);

    ParagraphConstraints constraints = ParagraphConstraints(width: 200.0);
    Paragraph paragraph = builder.build()..layout(constraints);

    canvas.drawParagraph(paragraph,new Offset(50.0,100.0));

  }

}