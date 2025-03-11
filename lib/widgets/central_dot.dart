import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'feature_dot.dart';
import '../screens/prayer_times_screen.dart';
import '../screens/prayer_tracker_screen.dart';
import '../screens/request_dua_screen.dart';
import '../screens/meet_screen.dart';

class CentralDot extends StatefulWidget {
  const CentralDot({Key? key}) : super(key: key);

  @override
  State<CentralDot> createState() => _CentralDotState();
}

class _CentralDotState extends State<CentralDot> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  final List<FeatureItem> features = const [
    FeatureItem("Prayer Times", Icons.access_time, Colors.teal, 'prayer_times'),
    FeatureItem("Prayer Tracker", Icons.check_circle_outline, Colors.blue, 'prayer_tracker'),
    FeatureItem("Request Dua", Icons.favorite, Colors.red, 'request_dua'),
    FeatureItem("Meet", Icons.people, Colors.purple, 'meet'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // Longer animation duration
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _navigateToFeature(BuildContext context, FeatureItem feature) {
    _toggleExpansion();
    
    // Navigate based on the feature
    Widget screen;
    switch (feature.route) {
      case 'prayer_times':
        screen = const PrayerTimesScreen();
        break;
      case 'prayer_tracker':
        screen = const PrayerTrackerScreen();
        break;
      case 'request_dua':
        screen = const RequestDuaScreen();
        break;
      case 'meet':
        screen = const MeetScreen();
        break;
      default:
        return;
    }
    
    // Delayed navigation for smooth animation
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => screen,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main dot
        GestureDetector(
          onTap: _toggleExpansion,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.touch_app,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Feature dots - now appearing after the main dot for proper stacking
        ..._buildFeatureDots(context),
      ],
    );
  }

  List<Widget> _buildFeatureDots(BuildContext context) {
    List<Widget> dots = [];
    
    final double radius = 150.0; // Slightly larger radius
    
    for (int i = 0; i < features.length; i++) {
      // Only show when expanded
      if (!_isExpanded) continue;
      
      final double angle = (i * 2 * math.pi / features.length);
      final double x = radius * math.cos(angle);
      final double y = radius * math.sin(angle);
      
      dots.add(
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          // Slower animation
          duration: const Duration(milliseconds: 800),
          // Smoother curve
          curve: Curves.easeOutBack,
          // Longer staggered delay
          onEnd: () {
            // Small bounce effect at the end
            setState(() {});
          },
          builder: (context, double value, child) {
            // Scale up from center of main dot
            return Transform.translate(
              offset: Offset(x * value, y * value),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: value,
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: FeatureDot(
                      feature: features[i],
                      onTap: () => _navigateToFeature(context, features[i]),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    
    return dots;
  }
}