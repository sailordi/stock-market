import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/stockHistoryData.dart';

class ChartWidget extends StatelessWidget {
  final List<StockHistoryData> data;

  const ChartWidget({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: const DateTimeAxis(),
        series: <CartesianSeries>[
          // Renders line chart
          LineSeries<StockHistoryData, DateTime>(
              dataSource: data,
              xValueMapper: ( StockHistoryData d, _) => d.date,
              yValueMapper: ( StockHistoryData d, _) => d.price
          )
        ]
    );
  }

}