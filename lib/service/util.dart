import 'package:flutter/cupertino.dart';

const List<String> _filter  = [
//  'database/',
//  'graph',
//  'main.dart'
//    'database'
     'groups'
];



class Util {
  final StackTrace _trace;

  Util(this._trace);

  void out(String message) {

    var frames = this._trace.toString().split("\n");
    var traceString = frames[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_/]+.dart'));
    var fileInfo = indexOfFileName != -1? traceString.substring(indexOfFileName) : '?';
    String x = fileInfo.toString().toLowerCase();
    bool f = _filter.length == 0;
    String mf = message.toLowerCase();

    for (String s in _filter){
      if (x.indexOf(s) != -1 || mf.indexOf(s) != -1){
        f = true;
        break;
      }
    }

    if (f) debugPrint('>> ' + message + '  [' + fileInfo + ']');
  }

  static String id (int id){
    if (id == null) return 'null';
    return id.toString();
  }


  static String timeFormat(int seconds) {
    if (seconds == null) return '';
    int h = seconds ~/ 3600;
    int r = seconds % 3600;
    int m = r ~/ 60;
    int s = r % 60;
    return (h != 0 ? h.toString() + ':' : '') +
        (m != 0 || h > 0 ? (m < 10 ? '0' : '') + m.toString() + ':' : '') +
        (s < 10 && seconds > s ? '0' : '') +
        s.toString();
  }
}
