import 'dart:async';
import 'package:focus/entity/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:focus/service/util.dart';

class SessionBloc {
  final util = Util(StackTrace.current);
  final _lang = BehaviorSubject<String>();

  initialise (User user){
    util.out('Session initialise, lang=' + user.language);

    changeLanguage(user.language);
  }


  //Get data from stream
  Stream<String> get language => _lang.stream;

  //Set data
  Function(String) get changeLanguage => _lang.sink.add;

  dispose (){
    util.out('disposed called');
    _lang.close();
  }
}

