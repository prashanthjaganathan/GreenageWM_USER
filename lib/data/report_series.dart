import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ReportSeries {
  final String month;
  final int reports;

  final charts.Color barColor;

  ReportSeries(
      {required this.month, required this.reports, required this.barColor});
}

Map<String, int> reportsPermonth = {
  'January': 0,
  'February': 0,
  'March': 0,
  'April': 0,
  'May': 0,
  'June': 0,
  'July': 0,
  'August': 0,
  'September': 0,
  'October': 0,
  'November': 0,
  'December': 0,
};

final List<ReportSeries> report_data = [
  ReportSeries(
    month: "1",
    reports: reportsPermonth['January'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "2",
    reports: reportsPermonth['February'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "3",
    reports: reportsPermonth['March'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "4",
    reports: reportsPermonth['April'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "5",
    reports: reportsPermonth['May'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "6",
    reports: reportsPermonth['June'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "7",
    reports: reportsPermonth['July'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "8",
    reports: reportsPermonth['August'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "9",
    reports: reportsPermonth['September'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "1O",
    reports: reportsPermonth['October'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "11",
    reports: reportsPermonth['November'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
  ReportSeries(
    month: "12",
    reports: reportsPermonth['December'] as int,
    barColor: charts.ColorUtil.fromDartColor(Colors.green),
  ),
];
