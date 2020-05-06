import 'dart:io';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/service/util.dart';
import 'package:focus/service/error.dart';

class GraphBuild {
  List<double> numbers = List<double>();
  bool _stop = false;
  int _count = 0;
  int id;

  GraphBuild(this.id) {
  }

  void stop() {
    _stop = true;
  }

  bool isRunning(){
    return !_stop;
  }


//  void start() async {
//      while (!_stop) {
//      double x = _count.ceilToDouble();
//      Util(StackTrace.current).out('graph number ' + x.toString());
//      numbers.add(x);
//      _controller.sink.add(numbers);
//      sleep(const Duration(seconds: 1));
//      if (_count++>2) break;
//    }
//    _stop = true;
//  }

  dynamic start(_) async {
    double x = _count.ceilToDouble();
    Util(StackTrace.current).out('graph number ' + x.toString());
    numbers.add(x);
    _controller.sink.add(numbers);
    _count++;

    if(!_stop && _count<30) {
      new Future.delayed(const Duration(seconds: 1), (){}).then(start);
    }
    return null;
//    return Future.value(true);
  }

  final _controller = StreamController<List<double>>();
  Stream<List<double>> get stream => _controller.stream;


  static addGraphToStore (Store<AppState> store) async {
    if (store.state.isGraphBlocRunning()){
      throw FocusError(message: 'GraphBloc is already running');
    }
    store.state.graph = GraphBuild(-1);
    store.state.graph.start(true);
  }

}
