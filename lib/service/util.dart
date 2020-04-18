import 'package:flutter/cupertino.dart';

class Util {
  final StackTrace _trace;

  Util(this._trace);

  void out(String message) {
    var frames = this._trace.toString().split("\n");
    var traceString = frames[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z]+.dart'));
    var fileInfo = traceString.substring(indexOfFileName);

    debugPrint('>> ' + message + '  [' + fileInfo + ']');
  }


}
