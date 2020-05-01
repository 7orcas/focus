import 'package:flutter/cupertino.dart';

const List<String> _filter  = [
  'database/',
  'group/',
//  'main.dart'
];



class Util {
  final StackTrace _trace;

  Util(this._trace);

  void out(String message) {
    var frames = this._trace.toString().split("\n");
    var traceString = frames[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_/]+.dart'));
    var fileInfo = indexOfFileName != -1? traceString.substring(indexOfFileName) : '?';
    String x = fileInfo.toString();
    bool f = _filter.length == 0;

    for (String s in _filter){
      if (x.indexOf(s) != -1){
        f = true;
        break;
      }
    }

    if (f) debugPrint('>> ' + message + '  [' + fileInfo + ']');
  }


}
