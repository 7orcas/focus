import 'dart:io';
import 'package:test/test.dart';
import 'package:focus/model/group/graph/graph_build.dart';

void main() {

  test('Timer', () {
    ClockTimer b = ClockTimer((){});
    b.status = RunStatus.RUNNING;
    b.start();
  });

  test('Timer format', () {

    List<Object> times = [
      0,    '0',
      5,    '5',
      10,   '10',
      61,   '01:01',
      150,  '02:30',
      3600, '1:00:00',
      3752, '1:02:32',
      37520,'10:25:20',
    ];

    ClockTimer b = ClockTimer((){});
    for (int i=0; i<times.length; i+=2){
      expect(times[i+1], b.timeFormat(times[i]));
      print (b.timeFormat(times[i]));
    }

  });


}
