import 'package:focus/service/util.dart';

// Actions that can mutate the state

final util = Util(StackTrace.current);


class LoadAppAction {
  LoadAppAction(){
    util.out('LoadAppAction constructor');
  }
}

class RefreshAppAction {}