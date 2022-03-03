import 'package:flutter/material.dart';
import 'package:pedometer_test/app/app.locator.dart';
import 'package:pedometer_test/pedometer_view.dart';


void main() {
   setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedometer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PedometerView()
    );
  }
}

