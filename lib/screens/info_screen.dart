import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset("assets/logo.png", height: 100),
            const SizedBox(height: 20),
            const Text("mxlive", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Version 1.0.0"),
            const SizedBox(height: 30),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Developer Info", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Developed by: Your Name/Team"),
                    Text("Contact: dev@example.com"),
                    Text("Tech: Flutter & Dart"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
