import 'package:charts_flutter/flutter.dart';
import 'package:charts_common/src/chart/cartesian/axis/numeric_tick_provider.dart';
import 'package:focus/model/group/graph/graph_build.dart';

class FocusChart extends LineChart {
  FocusChart(List<Series<RngPoint, int>> chartData, List<ChartBehavior> titles)
      : super(chartData,
            behaviors: titles,
            primaryMeasureAxis: NumericAxisSpec(
              renderSpec: SmallTickRendererSpec(),
              showAxisLine: true,
              tickProviderSpec: TickProviderSpec(),
            )) {}

  static List<ChartBehavior> titles(Function lang, {Color color : Colors.white}) {
    return [
      new ChartTitle(lang('GraphTitle'),
          behaviorPosition: BehaviorPosition.top,
          titleStyleSpec: TextStyleSpec(fontSize: 11),
          titleOutsideJustification: OutsideJustification.middleDrawArea),
      new ChartTitle(lang('GraphX'),
          behaviorPosition: BehaviorPosition.bottom,
          titleStyleSpec: TextStyleSpec(fontSize: 11),
          titleOutsideJustification: OutsideJustification.middleDrawArea),
      new ChartTitle(lang('GraphY'),
          behaviorPosition: BehaviorPosition.start,
          titleStyleSpec: TextStyleSpec(fontSize: 11),
          titleOutsideJustification: OutsideJustification.middleDrawArea)
    ];
  }
}

class TickProviderSpec implements NumericTickProviderSpec {
  final bool zeroBound = true;
  final bool dataIsInWholeNumbers = false;
  final int desiredTickCount = 6;
  final int desiredMinTickCount = 6;
  final int desiredMaxTickCount = 6;

  @override
  NumericTickProvider createTickProvider(ChartContext context) {
    final provider = NumericTickProvider();
//    provider.getTicks(context: null, graphicsFactory: null, scale: null, formatter: null, formatterValueCache: null, tickDrawStrategy: null, orientation: null)
//    provider.createTicks([0,0.25,0.5,0.75,1], context: context,
//        graphicsFactory: provider.getTicks().graphicsFactory,
//        scale: null,
//        formatter: null,
//        formatterValueCache: null,
//        tickDrawStrategy: null
//    );
    if (zeroBound != null) {
      provider.zeroBound = zeroBound;
    }
    if (dataIsInWholeNumbers != null) {
      provider.dataIsInWholeNumbers = dataIsInWholeNumbers;
    }

    if (desiredMinTickCount != null ||
        desiredMaxTickCount != null ||
        desiredTickCount != null) {
      provider.setTickCount(desiredMaxTickCount ?? desiredTickCount ?? 10,
          desiredMinTickCount ?? desiredTickCount ?? 2);
    }
    return provider;
  }

  @override
  bool operator ==(Object other) =>
      other is BasicNumericTickProviderSpec &&
      zeroBound == other.zeroBound &&
      dataIsInWholeNumbers == other.dataIsInWholeNumbers &&
      desiredTickCount == other.desiredTickCount &&
      desiredMinTickCount == other.desiredMinTickCount &&
      desiredMaxTickCount == other.desiredMaxTickCount;

  @override
  int get hashCode {
    int hashcode = zeroBound?.hashCode ?? 0;
    hashcode = (hashcode * 37) + dataIsInWholeNumbers?.hashCode ?? 0;
    hashcode = (hashcode * 37) + desiredTickCount?.hashCode ?? 0;
    hashcode = (hashcode * 37) + desiredMinTickCount?.hashCode ?? 0;
    hashcode = (hashcode * 37) + desiredMaxTickCount?.hashCode ?? 0;
    return hashcode;
  }
}
