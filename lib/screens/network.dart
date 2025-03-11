import 'package:flutter/material.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
        backgroundColor: Color.fromARGB(255, 0, 121, 109),
      ),
      body: const Center(
        child: Text(
          'Network Feature',
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}