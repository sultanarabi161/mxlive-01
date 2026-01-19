import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Info")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png", height: 100),
              const SizedBox(height: 20),
              const Text("MXLive", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              const Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  children: [
                    Text("Developer Info", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    Divider(color: Colors.grey),
                    Text("Dev: Sultan Arabi"),
                    Text("Contact: sultanarabi161@gmail.com"),
                    SizedBox(height: 10),
                    Text("Powered by Flutter"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
