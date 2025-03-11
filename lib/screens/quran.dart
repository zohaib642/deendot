import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        backgroundColor: Color.fromARGB(255, 0, 121, 109),
      ),
      body: const Center(
        child: Text(
          'Quran Feature',
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}