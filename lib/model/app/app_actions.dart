import 'package:focus/service/util.dart';
import 'package:focus/model/base_action.dart';


class LoadAppAction extends BaseAction{
  LoadAppAction(){
    Util(StackTrace.current).out('LoadAppAction constructor');
  }
}

class RefreshAppAction extends BaseAction{}
