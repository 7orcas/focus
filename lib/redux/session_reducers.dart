import 'package:focus/model/session.dart';
import 'package:focus/redux/session_actions.dart';

// Define peer functions that change state

Session sessionReducer(Session state, action){

  if (action is ChangeLanguageAction){
    return Session(language: action.language);
  }
  if (action is LoadLanguageAction){
    return Session(language: action.language);
  }

  return state;
}