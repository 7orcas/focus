import 'package:focus/service/error.dart';

class BaseAction {
  error(FocusError error){
    print('ERROR: ' + error.message);
  }

}
