import 'package:focus/bloc/session_bloc.dart';
import 'package:focus/bloc/session_provider.dart';
export 'package:focus/bloc/session_provider.dart';
import 'package:flutter/material.dart';

class SessionProvider extends InheritedWidget {
  final SessionBloc bloc;

  SessionProvider ({Key key, Widget child})
  : bloc = SessionBloc(),
  super (key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  //Todo
  static SessionBloc of (BuildContext context){
    return (context.inheritFromWidgetOfExactType(SessionProvider) as SessionProvider)
        .bloc;
  }

}
