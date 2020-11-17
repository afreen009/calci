import 'package:flutter/material.dart';

import 'services/service_locator.dart';
import 'todo/calculator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimpleCalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}