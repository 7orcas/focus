import 'package:sqflite/src/exception.dart';

class FocusError {
  String _message;
  var _error;

  FocusError({message, error}) {
    assert(message != null);
    this._message = message;
    this._error = error;
  }

  String get message => _message;
  Object get error => _error;

  String details (){
    if (_error == null) return '';

    switch(_error.runtimeType){
      case Error: return _error.toString();

      case SqfliteDatabaseException: return _error.toString();

    }
    return "?";
  }

}