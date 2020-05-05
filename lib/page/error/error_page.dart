import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/service/error.dart';
import 'package:focus/service/language.dart';
import 'package:redux/redux.dart';

class ErrorPage extends StatelessWidget {
  final FocusError _error;

  ErrorPage(this._error);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          Language lang = Language(viewModel.session.langCode);

          return new Scaffold(
              appBar: new AppBar(
                title: new Text(lang.label('Error')),
              ),
              body: new Center(
                child: Column(
                  children: <Widget>[
                    Text('Opps, ' + _error.message),
                    Spacer(),
                    Text(_error.details())
                  ],
                ),
              ));
        });
  }
}

class _ViewModel {
  final Session session;

  _ViewModel({
    this.session,
  });

  factory _ViewModel.create(Store<AppState> store) {
    return _ViewModel(
      session: store.state.session,
    );
  }
}
