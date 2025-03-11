import 'package:flutter/material.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer'),
        backgroundColor: Color.fromARGB(255, 0, 121, 109),
      ),
      body: const Center(
        child: Text(
          'Prayer Feature',
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}