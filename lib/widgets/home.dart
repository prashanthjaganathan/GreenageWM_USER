import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/data/education_data.dart';
import 'package:flutter_application_1/data/pickup_history_data.dart';
import 'package:flutter_application_1/data/pickup_order.dart';
import 'package:flutter_application_1/data/report_series.dart';
import 'package:flutter_application_1/data/reports_data.dart';
import 'package:flutter_application_1/data/smart_bins_loc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/data/profile_data.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/screens/education.dart';
import 'package:flutter_application_1/screens/pick_up.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/report.dart';
import 'package:flutter_application_1/screens/smart_bin_map.dart';
import 'package:mysql1/mysql1.dart';

dynamic conn;
UserData obj = UserData();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _list = [
    const SmartBinMap(),
    const PickUp(),
    const Report(),
    const Education(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: '34.93.37.194',
          port: 3306,
          user: 'root',
          password: 'root',
          db: 'greenage',
        ),
      );

      {
        final results = await conn.query('SELECT * FROM USERS WHERE `id` = 2');
        for (var row in results) {
          print(row.toString());
          // Setting up user data
          obj.setID = await row['id'];
          obj.setName = await row['Full_Name'];
          obj.setPhone = row['Phone'].toString();
          obj.setEmail = await row['Email'];
          obj.setAddress = row['Address'].toString();
          obj.setAddressName = row['Address_Name'].toString();
          obj.setRewardPoints = await row['Reward_Points'];
          obj.setVouchers = await row['VOUCHERS'];
          obj.setDp = row['DP'].toString();

          // Retrieving DP from the Database
          Uint8List bytes = base64.decode(obj.getDp);
          String tempPath =
              await getTemporaryDirectory().then((value) => value.path);
          String filePath =
              '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpeg';
          await File(filePath).writeAsBytes(bytes);
          dp = XFile(filePath);

          // Setting up profile data
          name = obj.getName;
          emailID = obj.getEmail;
          mobile = obj.getPhone;
          points = obj.getRewardPoints;
          vouchers = obj.getVouchers;

          // Setting up pickup_order.dart
          pickupAddressName = obj.getAddressName;
          pickupAddress = obj.getAddress;
          String s = pickupAddress.trim();
          List<String> words = s.split(" ");
          pickupAddressBrief = words[words.length - 1];
        }
        final getTotalReports = await conn.query(
            'select COUNT(user_id) from REPORTS group by `user_id` having `user_id` = ${obj.getID}');
        for (var row in getTotalReports) {
          var temp = await row['COUNT(user_id)'];
          totalReports = temp ?? 0;
        }

        final getSuccessReports = await conn.query(
            'select COUNT(`user_id`) from REPORTS group by `user_id`, `status` having `user_id` = ${obj.getID} AND `status` = "Success"');
        for (var row in getSuccessReports) {
          var temp = await row['COUNT(status)'];
          successfulReports = temp ?? 0;
        }

        final getPoints = await conn.query(
            'select SUM(points_earned) from REPORTS group by `user_id` having `user_id` = ${obj.getID}');
        for (var row in getPoints) {
          var temp = await row['SUM(points_earned)'];
          pointsEarnedByReports = temp ?? 0;
        }

        var myReports = await conn.query(
            'select title, status, report_id from REPORTS where user_id = ${obj.getID}');
        for (var row in myReports) {
          reportHistory.add(row);
        }

        var myPickups = await conn.query(
            'select pickup_id, disposal_size, address, total_bill, points_earned from PICKUPS where `user_id` = ${obj.getID}');
        for (var row in myPickups) {
          pickupHistory.add(row);
        }

        var reportsGraphData = await conn.query(
            'select date_format(`date`, "%M"), COUNT(`report_id`) from REPORTS group by date_format(`date`, "%M")');
        for (var row in reportsGraphData) {
          reportsPermonth[row[0]] = row[1];
          print(row[0]);
        }

        var eduVideos = await conn.query('select title from EDU_VIDEOS');
        for (var row in eduVideos) {
          educationalVideos.add(row['title'].toString());
          print(row);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 245, 242, 253),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: const Color.fromRGBO(96, 125, 139, 1),
        unselectedLabelStyle: const TextStyle(color: Colors.blueGrey),
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Bin Map',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.electric_scooter,
                size: 30,
              ),
              label: 'Pick Up'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.report,
                size: 30,
              ),
              label: 'Report'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.play_circle,
                size: 30,
              ),
              label: 'Edu'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'Profile'),
        ],
      ),
      body: _list[_selectedIndex],
    );
  }
}

void getData() async {
  print('Connecting to CloudSQL...');
  conn = await MySqlConnection.connect(
    ConnectionSettings(
      host: '34.93.37.194',
      port: 3306,
      user: 'root',
      password: 'root',
      db: 'greenage',
    ),
  );

  print('Connected');

  {
    final results = await conn.query('SELECT * FROM USERS WHERE `id` = 2');
    for (var row in results) {
      print(row.toString());
      // Setting up user data
      obj.setID = await row['id'];
      obj.setName = await row['Full_Name'];
      obj.setPhone = row['Phone'].toString();
      obj.setEmail = await row['Email'];
      obj.setAddress = row['Address'].toString();
      obj.setAddressName = row['Address_Name'].toString();
      obj.setRewardPoints = await row['Reward_Points'];
      obj.setVouchers = await row['VOUCHERS'];
      obj.setDp = await row['DP'].toString();

      // Retrieving DP from the Database
      Uint8List bytes = base64.decode(obj.getDp);
      String tempPath =
          await getTemporaryDirectory().then((value) => value.path);
      String filePath =
          '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpeg';
      await File(filePath).writeAsBytes(bytes);
      dp = XFile(filePath);

      // Setting up profile data
      name = obj.getName;
      emailID = obj.getEmail;
      mobile = obj.getPhone;
      points = obj.getRewardPoints;
      vouchers = obj.getVouchers;
    }
  }
}
