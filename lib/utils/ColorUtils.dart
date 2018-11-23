
import 'dart:ui';

class ColorUtils{

  /*完成  绿色*/
  static var colorFinishGreen = 0xFF45BF1A;

  /*按钮边框 绿色*/
  static var colorButtonGreen = 0xFF45BF1A;

  /*分割线 灰色*/
  static var colorDividingLineGrey = 0xFFDFDFE2;

  /*文字 黑色FF020202*/
  static var colorTextBlackFF020202 = 0xFF020202;

  /*文字 灰色FF020202*/
  static var colorTextGreyFF777777 = 0xFF777777;

  static List<Color> getColorList(){
    List<Color> list = new List();
    list.add(Color(0xFFD8D8D9));//白色
    list.add(Color(0xFF000000));
    list.add(Color(0xFFFF3737));
    list.add(Color(0xFFFF5400));
    list.add(Color(0xFF45BF1A));
    list.add(Color(0xFF2462FF));
    list.add(Color(0xFF2462FF));
    list.add(Color(0xFFDD24FF));
    list.add(Color(0xFFFF3BAE));
    return list;
  }

}