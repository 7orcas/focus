import 'package:focus/service/util.dart';

// Actions that can mutate the state

final util = Util(StackTrace.current);

class ChangeLanguageAction {
  final String language;

  ChangeLanguageAction(this.language){
    util.out('ChangeLanguageAction constructor');
  }

}

class GetLanguageAction {
  GetLanguageAction(){
    util.out('GetLanguageAction constructor');
  }
}

class LoadLanguageAction {
  final String language;

  LoadLanguageAction(this.language){
    util.out('LoadLanguageAction constructor');
  }

}