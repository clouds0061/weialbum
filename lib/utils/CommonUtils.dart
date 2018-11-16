class CommonUtils {


  //处理string
  static List<String> getList(String listString) {
    List<String> list = new List();
    list.addAll(listString.split(';'));
    return list;
  }

}