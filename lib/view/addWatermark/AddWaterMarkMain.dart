import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:wei_album/view/addWatermark/Image.dart';


class AddWaterMarkMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddWaterMarkMainState();
}

class AddWaterMarkMainState extends State<AddWaterMarkMain> {

  ui.Image image;
  GlobalKey<ImageState> signatureKey = new GlobalKey();
  bool finish = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    finish = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: '',
        home: Scaffold(
            appBar: AppBar(title: Text('测试'),leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
            ),),
            body: finish == true
                ? MyImage(image, key: signatureKey)
                : CircularProgressIndicator(),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  var image = signatureKey.currentState.getImage;
                  _saveImage(image);
                },
                ),
            ),
        );
  }

  Future getImage() async {
//    Uint8List list;
    await ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      file.readAsBytes().then((list) {
        ui.decodeImageFromList(list, (img) {
          setState(() {});
          image = img;
          finish = true;
//          generateImage;
        });
      });
    });
  }

  Future _saveImage(ui.Image image) async {
    try {
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
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
}