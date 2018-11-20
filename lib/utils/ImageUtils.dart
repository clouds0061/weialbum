import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';



const kCanvasSize = 200.0;

class ImageUtils {

  static ImageUtils _utils;

  static ImageUtils getInstance() {
    if (_utils == null) {
      _utils = new ImageUtils();
    }
    return _utils;
  }


  static File file;


  Future init(Image image, File f) async {
    file = f;
    Uint8List list;
    // from widget Image
    var provider = image?.image;

    print('provider: $provider');
    assert(provider != null);
    await getList(provider).then((list) {
      print('list : $list');
      if (list != null) {
        ui.decodeImageFromList(list, (ui.Image img) {
          generateImage(img).then((_) {
            return 'result $_';
          });
        });
      } else {
        // todo other image provider should be support
        print("no support image");
        return ('no support image');
      }
    });
  }


  Future<Uint8List> getList(var provider) async {
    Uint8List list;
    var config = new ImageConfiguration();
    if (provider is AssetImage) {
      AssetBundleImageKey key = await provider.obtainKey(config);
      final ByteData data = await key.bundle.load(key.name);
      list = data.buffer.asUint8List();
    } else if (provider is ExactAssetImage) {
      AssetBundleImageKey key = await provider.obtainKey(config);
      final ByteData data = await key.bundle.load(key.name);
      list = data.buffer.asUint8List();
    } else if (provider is NetworkImage) {
      NetworkImage key = await provider.obtainKey(config);
      list = await _loadNetImage(key);
    } else if (provider is FileImage) {
      print('get list start');
      list = await provider.file.readAsBytes();
    } else if (provider is MemoryImage) {
      list = provider.bytes;
    }
    print('list : $list');
    return list;
  }

  static Future generateImage(ui.Image image) async {
    final color = Colors.blueAccent;
    print('image : $image');
    final recorder = new ui.PictureRecorder();
    final canvas = new Canvas(
        recorder,
        new Rect.fromPoints(
            new Offset(0.0, 0.0), new Offset(kCanvasSize, kCanvasSize)));

    final stroke = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        new Rect.fromLTWH(0.0, 0.0, kCanvasSize*2, kCanvasSize*2), stroke);
//    var paint = new Paint();
//    paint.color = color;
    paintImage(
        image, new Rect.fromLTRB(0.0, 0.0, kCanvasSize, kCanvasSize), canvas,
        stroke, BoxFit.cover);
    canvas.drawCircle(new Offset(100.0,100.0),20,stroke);
    ui.ParagraphBuilder builder = new ui.ParagraphBuilder(
        new ui.ParagraphStyle());
    builder.addText('啊啊啊啊');
    ui.Paragraph paragraph = builder.build();
    canvas.drawParagraph(
        paragraph, new Offset(kCanvasSize / 2, kCanvasSize / 2));

//    final paint = new Paint()
//      ..color = color
//      ..style = PaintingStyle.fill;
//
//    canvas.drawCircle(
//        new Offset(
//            1.0 * kCanvasSize,
//            1.0 * kCanvasSize,
//            ),
//        20.0,
//        paint);

    final picture = recorder.endRecording();
    final img = picture.toImage(200, 200);
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    List<int> list = new List();
    print('pngBytes: ${new Uint8List.view(pngBytes.buffer)}');
//    new Uint8List.view(pngBytes.buffer);
    file.writeAsBytes(new Uint8List.view(pngBytes.buffer)).then((_) {
      return 'success path = ${_.path}';
    });
//    file.writeAsString(pngBytes.toString()).then((_) {
//      return 'success path = ${_.path}';
//    });
  }


  static void paintImage(ui.Image image, Rect outputRect, Canvas canvas,
      Paint paint, BoxFit fit) {
    print('paint image : $image');
    final Size imageSize = new Size(
        image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
    final Rect inputSubrect = Alignment.center.inscribe(
        sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect = Alignment.center.inscribe(
        sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
  }


  static final HttpClient _httpClient = new HttpClient();
  final Map<String, String> headers = {};

  Future<Uint8List> _loadNetImage(NetworkImage key) async {
    final Uri resolved = Uri.base.resolve(key.url);
    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.OK) throw new Exception(
        'HTTP request failed, statusCode: ${response?.statusCode}, $resolved');

    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    if (bytes.lengthInBytes == 0) throw new Exception(
        'NetworkImage is an empty file: $resolved');

    return bytes;
  }

}