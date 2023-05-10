import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Greenage Waste Management",
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        primarySwatch: Colors.green,
        textTheme:
            TextTheme(titleLarge: TextStyle(color: Colors.green.shade700)),
      ),
      home: const Home(),
    );
  }
}
