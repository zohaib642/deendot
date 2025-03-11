import 'package:flutter/material.dart';

class RequestDuaScreen extends StatelessWidget {
  const RequestDuaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Dua'),
        backgroundColor: Color.fromARGB(255, 0, 121, 109),
      ),
      body: const Center(
        child: Text(
          'Request Dua Feature',
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}