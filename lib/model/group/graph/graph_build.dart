import 'dart:async';
import 'dart:math';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/service/util.dart';
import 'package:charts_flutter/flutter.dart';

enum RunStatus { WAIT, RUNNING, PAUSED, STOPPED }

class GraphBuild {
  List numbers = List<double>();
  List _points = List<RngPoint>();
  RunStatus status = RunStatus.WAIT;
  int _count = 0;
  final _random = new Random();
  ClockTimer _timer;

  final _controller = StreamController<GraphBuild>();
  Stream<GraphBuild> get stream => _controller.stream;

  GraphBuild() {
    _timer = ClockTimer(() {_controller.sink.add(this);});
    _timer.start();
    _controller.sink.add(this);
  }

  void start() {
    if (status == RunStatus.STOPPED) return;
    status = RunStatus.RUNNING;
    _startRun(0);
    _timer.status = RunStatus.RUNNING;
  }

  void pause() {
    status = RunStatus.PAUSED;
    _timer.status = RunStatus.PAUSED;
    _controller.sink.add(this);
  }

  void stop() {
    status = RunStatus.STOPPED;
    _timer.status = RunStatus.STOPPED;
    _controller.sink.add(this);
    _controller.sink.close();
    _controller.close();
  }

  bool get isActive =>
      status == RunStatus.RUNNING || status == RunStatus.PAUSED;
  bool get isRunning => status == RunStatus.RUNNING;
  bool get isPaused => status == RunStatus.PAUSED;
  bool get isStopped => status == RunStatus.STOPPED;
  bool get isWaiting => status == RunStatus.WAIT;

  String timer() {
    return _timer.timeAsString();
  }

  void _startRun(_) async {
    if (_count > 10000) {
      stop();
      return;
    }
    if (status == RunStatus.STOPPED) {
      return;
    }

    if (status == RunStatus.RUNNING) {
      int z = 0;
      for (int i = 0; i < 200; i++) {
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

    new Future.delayed(const Duration(seconds: 1), () {})
        .then(_startRun); //ToDo put in session parameters
  }

  List<Series<RngPoint, int>> chartData() {
    return _getChartDataX(_points);
  }

  String toList(){
    StringBuffer b = StringBuffer();
    for (int i=0;i<numbers.length;i++){
      b.write((i>0?',':'') + numbers[i].toString());
    }
    return b.toString();
  }

  static List<double> fromList(String list){
    List<double> numbers = [];
    list.split(',').forEach((s) {
      numbers.add(double.parse(s));
    });
    return numbers;
  }


  static List<Series<RngPoint, int>> getChartData(List<double> numbers){
    List points = List<RngPoint>();
    for (int i=0;i<numbers.length;i++){
      points.add(RngPoint(i, numbers[i]));
    }
    return _getChartDataX(points);
  }

  static List<Series<RngPoint, int>> _getChartDataX(List<RngPoint> points){
    return [
      new Series<RngPoint, int>(
        id: 'RNG',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (RngPoint p, _) => p.point,
        measureFn: (RngPoint p, _) => p.value,
        data: points,
      )
    ];
  }

  static addGraphToStore(Store<AppState> store) async {
    if (store.state.isGraphBlocRunning()) {
      //throw FocusError(message: 'GraphBloc is already running');
      return;
    }
    Util(StackTrace.current).out('add graph build to store');
    store.state.graph = GraphBuild();
  }
}

/// RNG data type.
class RngPoint {
  final double value;
  final int point;

  RngPoint(this.point, this.value);
}

class ClockTimer {
  int _seconds = 0;
  RunStatus _status = RunStatus.WAIT;
  final Function _sink;

  ClockTimer(this._sink);

  int get seconds => _seconds;
  void set status(RunStatus s) => _status = s;

  void start() {
    _startTimer(0);
  }

  void _startTimer(_) async {
    if (_status == RunStatus.RUNNING){
      _seconds++;
      _sink();
    }
    if (_status == RunStatus.STOPPED) {
      return;
    }
    new Future.delayed(const Duration(seconds: 1), () {}).then(_startTimer);
  }

  String timeAsString() {
    return timeFormat(_seconds);
  }

  String timeFormat(int seconds) {
    int h = seconds ~/ 3600;
    int r = seconds % 3600;
    int m = r ~/ 60;
    int s = r % 60;
    return (h != 0 ? h.toString() + ':' : '') +
        (m != 0 || h > 0 ? (m < 10 ? '0' : '') + m.toString() + ':' : '') +
        (s < 10 && seconds > s ? '0' : '') +
        s.toString();
  }

//  final _timerController = StreamController<ClockTimer>();
//  Stream<ClockTimer> get stream => _timerController.stream;
}
