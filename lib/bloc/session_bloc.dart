import 'package:rxdart/rxdart.dart';

class SessionBloc {
  final _lang = BehaviorSubject<String>();


  //Get data from stream
  Stream<String> get lang => _lang.stream;

  //Set data
  Function(String) get changeLang => _lang.sink.add;

  dispose (){
    _lang.close();
}
}

