import 'package:flutter/material.dart';

class PictureWidget extends StatefulWidget{
  Image image1;
  Image image2;
  Function function;
  @override
  State<StatefulWidget> createState()=>PictureWidgetState(image1,image2,function);

  PictureWidget(this.image1, this.image2, this.function);


}

class PictureWidgetState extends State<PictureWidget>{
  Image image1;
  Image image2;
  Function function;


  PictureWidgetState(this.image1, this.image2, this.function);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(children: <Widget>[
      image1,
//          Center(child: image1,),
      Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: (){deletePic();},
              child: image2,
              ),
          ),
    ],
        alignment: AlignmentDirectional.center,);
  }

  void deletePic() {
      function();
  }

}