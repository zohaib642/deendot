import 'package:flutter/material.dart';
import '../widgets/central_dot.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // App title at the top
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Text(
                'DeenDot',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 65,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            
            // Central dot in the middle
            const Center(
              child: CentralDot(),
            ),
            
            // Bottom info text
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Text(
                'Tap the dot to explore features',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}