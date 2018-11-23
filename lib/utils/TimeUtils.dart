class TimeUtils {

  /*获取当前时间 yyyy-MM-dd*/
  static String getNowTimeyyyy_MM_dd() {
    DateTime now = new DateTime.now();
    String timeWithSeconds = now.toString();
    int startIndex = timeWithSeconds.indexOf(' ');
    String time = timeWithSeconds.substring(0, startIndex);
    return time;
  }

  /*获取当前时间 yyyy-MM-dd HH:mm:ss*/
  static String getNowTime() {
    DateTime now = new DateTime.now();
    return now.toString();
  }

  /*获取当前时间 yyyy_MM_dd_HH_mm_ss*/
  static String getNowTimeyyyy_MM_dd_HH_mm_ss(){
    StringBuffer buffer = new StringBuffer();
    DateTime now = new DateTime.now();
    String timeWithSeconds = now.toString();
    int startIndex = timeWithSeconds.indexOf(' ');
    String time = timeWithSeconds.substring(0, startIndex);
    String time1 = timeWithSeconds.substring(startIndex+1,timeWithSeconds.length);
    List<String> times = time.split('-');
    List<String> times1 = time1.split(':');
    for(int i =0;i<times.length;i++){
      buffer.write(times[i]);
    }
    for(int j = 0;j<times1.length;j++){
      buffer.write(times1[j]);
    }
    return buffer.toString();
  }

  //判断时间 具体离现在多久
  static String getTimeInDetails(String times) {
    String time = '刚刚';
    try {
      if(times.isEmpty||times==null) return '';
      DateTime now = new DateTime.now();
      int index = times.lastIndexOf('.');
      String _time = times.substring(0,index);
      print('******tiem*****$_time');
      DateTime oldTiem = DateTime.parse(_time);
      if (now.year == oldTiem.year) {
        if (now.month == oldTiem.month) {
          if (now.day == oldTiem.day) {
            if (now.hour == oldTiem.hour) {}
            else {
              time = '${now.hour - oldTiem.hour}小时前';
            }
          } else {
            time = '${now.day - oldTiem.day}天前';
          }
        } else {
          time = '${now.month - oldTiem.month}月前';
        }
      } else {
        time = '${now.year - oldTiem.year}年前';
      }
    } catch (e) {
      time = '';
      print('*******e*******$e');
    }
    return time;
  }

}