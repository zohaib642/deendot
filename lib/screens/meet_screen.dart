import 'package:flutter/material.dart';

class MeetScreen extends StatelessWidget {
  const MeetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Prayer Times Feature',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}