import 'dart:async';
import 'dart:math';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/service/util.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:focus/service/error.dart';

enum RunStatus {WAIT, STARTED, PAUSED, STOPPED}

class GraphBuild {
  List numbers = List<double>();
  List _points = List<RngPoint>();
  RunStatus status;
  int _count = 0;
  int id;
  final _random = new Random();

  GraphBuild(this.id) {
    status = RunStatus.WAIT;
    _controller.sink.add(this);
  }

  void start() {
    if (status == RunStatus.STOPPED) return;
    status = RunStatus.STARTED;
    _startRun(0);
  }
  void pause() {
    status = RunStatus.PAUSED;
    _controller.sink.add(this);
  }
  void stop() {
    status = RunStatus.STOPPED;
    _controller.sink.add(this);
  }

  bool get isActive => status == RunStatus.STARTED || status == RunStatus.PAUSED;
  bool get isRunning => status == RunStatus.STARTED;
  bool get isPaused => status == RunStatus.PAUSED;
  bool get isStopped => status == RunStatus.STOPPED;
  bool get isWaiting => status == RunStatus.WAIT;


  void _startRun(_) async {
    if(_count>10000) {
      stop();
      return;
    }
    if (status == RunStatus.STOPPED){
      return;
    }

    if (status == RunStatus.STARTED){
      int z = 0;
      for (int i = 0; i < 200; i++){
        int y = _random.nextInt(2);
        z += y;
      }
      double x = z.toDouble() / 200;
      Util(StackTrace.current).out('graph number ' + x.toString());
      numbers.add(x);
      _points.add(RngPoint(_count, x));
      _controller.sink.add(this);
      _count++;
    }

    new Future.delayed(const Duration(seconds: 1), (){}).then(_startRun); //ToDo put in session parameters
  }

  List<Series<RngPoint, int>> chartData() {
    return [
      new Series<RngPoint, int>(
        id: 'RNG',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (RngPoint p, _) => p.point,
        measureFn: (RngPoint p, _) => p.value,
        data: _points,
      )
    ];
  }

  final _controller = StreamController<GraphBuild>();
  Stream<GraphBuild> get stream => _controller.stream;

  static addGraphToStore (Store<AppState> store) async {
    if (store.state.isGraphBlocRunning()){
      //throw FocusError(message: 'GraphBloc is already running');
      return;
    }
    Util(StackTrace.current).out('add graph build to store');
    store.state.graph = GraphBuild(-1);
  }

}

/// RNG data type.
class RngPoint {
  final double value;
  final int point;

  RngPoint(this.point, this.value);
}