class Utils{

  static String getTimeInHrMin(int time){
    int hr=(time/60).round();
    int min=time%60;
    return '${hr}hr ${min}min';
  }
}