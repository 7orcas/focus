import 'package:focus/service/util.dart';

// Actions that can mutate the state

final util = Util(StackTrace.current);

class ChangeLanguageAction {
  final String langCode;

  ChangeLanguageAction(this.langCode){
    util.out('ChangeLanguageAction constructor');
  }

}

class GetLanguageAction {
  GetLanguageAction(){
    util.out('GetLanguageAction constructor');
  }
}

class LoadLanguageAction {
  final String langCode;

  LoadLanguageAction(this.langCode){
    util.out('LoadLanguageAction constructor');
  }

}