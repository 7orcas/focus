import 'package:focus/model/session/session.dart';
import 'package:focus/model/session/session_actions.dart';

// Define peer functions that change state

Session sessionReducer(Session state, action){

  if (action is ChangeLanguageAction){
    return Session(langCode: action.langCode);
  }
  if (action is LoadLanguageAction){
    return Session(langCode: action.langCode);
  }

  return state;
}