import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/group/graph/graph_build.dart';


class Runner {
  var _receiver;
  var _receive2;
  var _echoPort;
  GraphBuild _graph;
  RunStatus _status = RunStatus.WAIT;

  GraphBuild get graph => _graph;

  final _controller = StreamController<Runner>();
  Stream<Runner> get stream => _controller.stream;

  Runner(GraphBuild g){
    _graph = g;
    _receiver = ReceivePort();
    _receive2 = ReceivePort();
    _controller.sink.add(this);
  }

  void run() async{
    _status = RunStatus.WAIT;
    Util(StackTrace.current).out('isolate runner start');
    await Isolate.spawn<SendPort>(_entryPoint, _receiver.sendPort);
    _echoPort = await _receiver.first;
    _echoPort.send(_CrossIsolatesMessage<String>(sender: _receive2.sendPort, message: 'setup'));

    await for (_CrossIsolatesMessage msg in _receive2) {
      Util(StackTrace.current).out('isolate 2 runner msg=' + msg.message.toString());
      _graph.test(msg.message);
      _graph.timer = msg.seconds;
      _controller.sink.add(this);
    }
  }

  void start() {
    if (_status == RunStatus.STOPPED) return;
    _status = RunStatus.RUNNING;
    _echoPort.send(_CrossIsolatesMessage<String>(sender: null, message: 'start'));
  }

  void pause() {
    _status = RunStatus.PAUSED;
    _echoPort.send(_CrossIsolatesMessage<String>(sender: null, message: 'pause'));
  }

  void stop() {
    _status = RunStatus.STOPPED;
    _echoPort.send(_CrossIsolatesMessage<String>(sender: null, message: 'stop'));
  }

  bool get isActive =>
      _status == RunStatus.RUNNING || _status == RunStatus.PAUSED;
  bool get isRunning => _status == RunStatus.RUNNING;
  bool get isPaused => _status == RunStatus.PAUSED;
  bool get isStopped => _status == RunStatus.STOPPED;
  bool get isWaiting => _status == RunStatus.WAIT;
}

void _entryPoint(SendPort sendPort) async {
  var isolatePort = ReceivePort();
  sendPort.send(isolatePort.sendPort);
  GraphBuild graphIso = GraphBuild();
  SendPort replyToPort;
  bool initial = false;

  await for (_CrossIsolatesMessage msg in isolatePort) {
    Util(StackTrace.current).out('isolate entry point msg=' + msg.message);

    if (msg.message == 'setup') {
      replyToPort = msg.sender;
    }

    if (msg.message == 'start' && !initial) {
      initial = true;
      graphIso.start();
      graphIso.stream.listen((event) {
        Util(StackTrace.current).out('isolate listen event=' + event.numbers.toString());
        var isolatePort1 = ReceivePort();
        replyToPort.send(_CrossIsolatesMessage(sender: isolatePort1.sendPort, message: event.numbers, seconds: event.timer));
      });
    }
    else if (msg.message == 'start') {
      graphIso.start();
    }

    if (msg.message == 'pause') {
      graphIso.pause();
    }
    if (msg.message == 'stop') {
      graphIso.stop();
    }

  }

}

class _CrossIsolatesMessage<String> {
  final SendPort sender;
  final String message;
  final int seconds;

  _CrossIsolatesMessage({
    this.sender,
    this.message,
    this.seconds,
  });
}

