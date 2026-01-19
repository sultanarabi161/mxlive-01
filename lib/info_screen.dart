import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/logo.png', height: 100, errorBuilder: (_,__,___) => Icon(Icons.live_tv, size: 100))),
            SizedBox(height: 20),
            Text("App Name: mxlive", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Version: 1.0.0"),
            SizedBox(height: 20),
            Text("Developer Info:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("This app is developed using Flutter & Dart."),
            Text("Contact: admin@mxlive.com"),
          ],
        ),
      ),
    );
  }
}
