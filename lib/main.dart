import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(MxLiveApp());
}

class MxLiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mxlive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(),
    );
  }
}
