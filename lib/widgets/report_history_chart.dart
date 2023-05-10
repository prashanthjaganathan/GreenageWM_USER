import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../data/report_series.dart';

class ReportHistoryChart extends StatelessWidget {
  // const ReportHistoryChart({super.key});
  final List<ReportSeries> data;

  ReportHistoryChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ReportSeries, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (ReportSeries series, _) => series.month,
          measureFn: (ReportSeries series, _) => series.reports,
          colorFn: (ReportSeries series, _) => series.barColor)
    ];

    return SizedBox(
      height: 400,
      // padding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.BarChart(series, animate: true),
            )
          ],
        ),
      ),
    );
  }
}
