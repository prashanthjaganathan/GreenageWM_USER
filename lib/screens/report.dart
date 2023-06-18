import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/report_series.dart';
import 'package:flutter_application_1/data/reports_data.dart';
import 'package:flutter_application_1/screens/new_report.dart';
import 'package:flutter_application_1/widgets/home.dart';
import 'package:flutter_application_1/widgets/report_history_chart.dart';
import 'package:mysql1/mysql1.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int _totalReports = 0;

  loadReportStats() async {
    final getTotalReports = await conn.query(
        'select COUNT(user_id) from REPORTS group by `user_id` having `user_id` = ${obj.getID}');
    for (var row in getTotalReports) {
      print(row);
      var temp = await row['COUNT(user_id)'];
      if (temp == _totalReports) return;
      totalReports = _totalReports = temp ?? 0;
    }

    final getSuccessReports = await conn.query(
        'select COUNT(`user_id`) from REPORTS group by `user_id`, `status` having `user_id` = ${obj.getID} AND `status` = "Success"');
    for (var row in getSuccessReports) {
      print(row);
      var temp = await row['COUNT(status)'];
      successfulReports = temp ?? 0;
    }

    final getPoints = await conn.query(
        'select SUM(points_earned) from REPORTS group by `user_id` having `user_id` = ${obj.getID}');
    for (var row in getPoints) {
      print(row);
      var temp = await row['SUM(points_earned)'];
      pointsEarnedByReports = temp ?? 0;
    }

    var myReports = await conn.query(
        'select title, status, report_id from REPORTS where user_id = ${obj.getID}');
    if (_totalReports != 0) {
      reportHistory.add(myReports[_totalReports - 1]);
    }
    for (var row in myReports) {
      reportHistory.add(row);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration.zero, () async {
    //   final getTotalReports = await conn.query(
    //       'select COUNT(user_id) from REPORTS group by `user_id` having `user_id` = ${obj.getID}');
    //   for (var row in getTotalReports) {
    //     print(row);
    //     var temp = await row['COUNT(user_id)'];
    //     totalReports = temp ?? 0;
    //   }

    //   final getSuccessReports = await conn.query(
    //       'select COUNT(`user_id`) from REPORTS group by `user_id`, `status` having `user_id` = ${obj.getID} AND `status` = "Success"');
    //   for (var row in getSuccessReports) {
    //     print(row);
    //     var temp = await row['COUNT(status)'];
    //     successfulReports = temp ?? 0;
    //   }

    //   final getPoints = await conn.query(
    //       'select SUM(points_earned) from REPORTS group by `user_id` having `user_id` = ${obj.getID}');
    //   for (var row in getPoints) {
    //     print(row);
    //     var temp = await row['SUM(points_earned)'];
    //     pointsEarnedByReports = temp ?? 0;
    //   }

    //   var myReports = await conn.query(
    //       'select title, status, report_id from REPORTS where user_id = ${obj.getID}');
    //   for (var row in myReports) {
    //     reportHistory.add(row);
    //   }
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) => build(context));
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 10), () async {
      await loadReportStats();
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 253),
      appBar: AppBar(title: const Center(child: Text("Reports Summary"))),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 243, 233, 44),
                        Color.fromARGB(255, 208, 243, 33)
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Total Reports',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text('$totalReports'),
                        ]),
                  ),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 39, 176, 146),
                        Color.fromARGB(255, 152, 200, 240)
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Successful Reports',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text('$successfulReports')
                        ]),
                  ),
                )),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 195, 96, 57),
                      Color.fromARGB(255, 243, 184, 33)
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Total Points Earned',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text('$pointsEarnedByReports')
                      ]),
                ),
              ),
            ),
            const Text(
              ' Monthly Activity Chart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Card(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.white,
                child: ReportHistoryChart(data: report_data),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Text(
                ' Report History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            reportHistory.isEmpty
                ? Container(
                    color: Colors.white,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: reportHistory.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          leading:
                              Text('# R${reportHistory[index]['report_id']}'),
                          //subtitle: Text('${reportHistory[index]['location']}'),
                          tileColor: Colors.white,
                          title: Text('${reportHistory[index]['title']}'),
                          trailing: Text('${reportHistory[index]['status']}'
                              .toUpperCase()),
                        );
                      }),
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 130,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Text('New Report'),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const NewReport()));
            },
          ),
        ),
      ),
    );
  }
}
