import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'feature_dot.dart';
import '../screens/request_dua.dart';
import '../screens/prayer.dart';
import '../screens/network.dart';
import '../screens/quran.dart';

class CentralDot extends StatefulWidget {
  const CentralDot({Key? key}) : super(key: key);

  @override
  State<CentralDot> createState() => _CentralDotState();
}

class _CentralDotState extends State<CentralDot> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  final List<FeatureItem> features = [
  FeatureItem(
    "Request Dua", 
    Icons.volunteer_activism, 
    Color.fromARGB(255, 0, 121, 109), 
    'request_dua'
  ),
  FeatureItem(
    "Prayer", 
    Icons.mosque, 
    Color.fromARGB(255, 0, 121, 109), 
    'prayer'
  ),
  FeatureItem(
    "Network", 
    Icons.people, 
    Color.fromARGB(255, 0, 121, 109), 
    'network'
  ),
  FeatureItem(
    "Quran", 
    Icons.menu_book, 
    Color.fromARGB(255, 0, 121, 109), 
    'quran'
  ),
];


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      
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
  final navigator = Navigator.of(context, rootNavigator: true);
  
  Widget screen;
  switch (feature.route) {
    case 'request_dua': 
      screen = const RequestDuaScreen();
      break;
    case 'prayer': 
      screen = const PrayerScreen();
      break;
    case 'network': 
      screen = const NetworkScreen();
      break;
    case 'quran': 
      screen = const QuranScreen();
      break;
    default: 
      return;
  }

  final Color featureColor = feature.color;

  Future.delayed(const Duration(milliseconds: 1), () {
    _toggleExpansion(); // Delay collapsing the menu until transition starts

    navigator.push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeOutQuint;
          var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
          
          var fadeAnimation = animation.drive(tween);
          var scaleAnimation = Tween(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(0.3, 1.0, curve: Curves.easeOutQuint),
            ),
          );
          var slideAnimation = Tween(
            begin: Offset(0.0, 0.2),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(0.2, 1.0, curve: Curves.easeOutQuint),
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                children: [
                  Container(
                    color: Color.lerp(
                      Colors.transparent,
                      featureColor.withOpacity(0.1),
                      fadeAnimation.value,
                    ),
                  ),
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
            },
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
    children: [
      
      Positioned(
        left: MediaQuery.of(context).size.width / 2 - 62.5, 
        top: MediaQuery.of(context).size.height / 2 - 62.5, 
        child: GestureDetector(
          onTap: () {

            _toggleExpansion();
          },
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
      ),
      
      
      ..._buildFeatureDots(context),
    ],
  );
}

  List<Widget> _buildFeatureDots(BuildContext context) {
  List<Widget> dots = [];
  
  final double radius = 150.0;
  
  for (int i = 0; i < features.length; i++) {
    if (!_isExpanded) continue;
    
    final double angle = (i * 2 * math.pi / features.length);
    final double x = radius * math.cos(angle);
    final double y = radius * math.sin(angle);
    
    dots.add(
      Positioned(
        left: MediaQuery.of(context).size.width / 2 + x - 35, 
        top: MediaQuery.of(context).size.height / 2 + y - 35, 
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, double value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: value,
                child: FeatureDot(
                      feature: features[i],
                      onTap: () => _navigateToFeature(context, features[i]),
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  return dots;
}
}