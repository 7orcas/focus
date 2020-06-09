import 'package:focus/service/util.dart';
import 'package:focus/model/base_action.dart';

// Actions that can mutate the state

class ChangeLanguageAction extends BaseAction{
  final String langCode;
  ChangeLanguageAction(this.langCode){
    Util(StackTrace.current).out('ChangeLanguageAction constructor');
  }

}

class GetLanguageAction extends BaseAction{
  GetLanguageAction(){
    Util(StackTrace.current).out('GetLanguageAction constructor');
  }
}

class LoadLanguageAction extends BaseAction{
  final String langCode;
  LoadLanguageAction(this.langCode){
    Util(StackTrace.current).out('LoadLanguageAction constructor');
  }

}