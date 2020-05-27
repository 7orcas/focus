import 'dart:async';
import 'dart:isolate';
import 'package:focus/service/util.dart';
import 'package:focus/model/group/graph/graph_build.dart';

class Runner {
  Isolate _isolate;
  var _initialPort;
  var _receivePort;
  var _echoPort;
  GraphBuild _graph;
  RunStatus _status = RunStatus.WAIT;

  GraphBuild get graph => _graph;

  final _controller = StreamController<Runner>();
  Stream<Runner> get stream => _controller.stream;

  Runner(GraphBuild g) {
    _graph = g;
    _initialPort = ReceivePort();
    _receivePort = ReceivePort();
    _controller.sink.add(this);
  }

  void run() async {
    _status = RunStatus.WAIT;
    Util(StackTrace.current).out('isolate runner start');
    _isolate = await Isolate.spawn<SendPort>(_isolatePoint, _initialPort.sendPort);
    _echoPort = await _initialPort.first;
    _echoPort.send(
        _CrossIsolatesMessage(sender: _receivePort.sendPort, message: 'setup'));

    await for (_CrossIsolatesMessage msg in _receivePort) {
      Util(StackTrace.current)
          .out('from isolate msg=' + msg.message.toString());

      if (msg.numbers != null){
        _graph.setNumbers(msg.numbers);
      }
      else{
        _graph.setNumber(msg.lastNumber, msg.lastRngPoint);
      }
      _graph.timer = msg.seconds;
      _controller.sink.add(this);

      if (_status == RunStatus.STOPPED){
        _isolate.kill();
      }
    }
  }

  void start() {
    if (_status == RunStatus.STOPPED) return;
    _status = RunStatus.RUNNING;
    _echoPort.send(_CrossIsolatesMessage(message: 'start'));
  }

  void pause() {
    _status = RunStatus.PAUSED;
    _echoPort.send(_CrossIsolatesMessage(message: 'pause'));
  }

  void stop() {
    _status = RunStatus.STOPPED;
    _echoPort.send(_CrossIsolatesMessage(message: 'stop'));
  }

  bool get isActive =>
      _status == RunStatus.RUNNING || _status == RunStatus.PAUSED;
  bool get isRunning => _status == RunStatus.RUNNING;
  bool get isPaused => _status == RunStatus.PAUSED;
  bool get isStopped => _status == RunStatus.STOPPED;
  bool get isWaiting => _status == RunStatus.WAIT;
}

void _isolatePoint(SendPort sendPort) async {
  var isolatePort = ReceivePort();
  sendPort.send(isolatePort.sendPort);

  GraphBuild graphIso = GraphBuild();
  bool initial = false;
  SendPort replyToPort;

  await for (_CrossIsolatesMessage msg in isolatePort) {
    Util(StackTrace.current).out('isolate entry point msg=' + msg.message);

    switch (msg.message) {
      case 'setup':
        replyToPort = msg.sender;
        break;
      case 'start':
        graphIso.start();
        break;
      case 'pause':
        graphIso.pause();
        break;
      case 'stop':
        graphIso.stop();
        // Resend graph
        replyToPort.send(_CrossIsolatesMessage(
            numbers: graphIso.numbers,
            seconds: graphIso.timer));
        break;
    }

    if (msg.message == 'start' && !initial) {
      initial = true;
      graphIso.stream.listen((build) {
        Util(StackTrace.current)
            .out('isolate listen graphBuild=' + build.lastNumber.toString());
        var isolatePort1 = ReceivePort();
        replyToPort.send(_CrossIsolatesMessage(
            sender: isolatePort1.sendPort,
            lastNumber: build.lastNumber,
            lastRngPoint: build.lastRngPoint,
            seconds: build.timer));
      });
    }
  }
}

class _CrossIsolatesMessage {
  final SendPort sender;
  final String message;
  final List<double> numbers;
  final double lastNumber;
  final RngPoint lastRngPoint;
  final int seconds;

  _CrossIsolatesMessage({
    this.sender,
    this.message,
    this.numbers,
    this.lastNumber,
    this.lastRngPoint,
    this.seconds,
  });
}
