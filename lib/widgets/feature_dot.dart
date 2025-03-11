import 'package:flutter/material.dart';

class FeatureItem {
  final String name;
  final IconData icon;
  final Color color;
  final String route;

  const FeatureItem(this.name, this.icon, this.color, this.route);
}

class FeatureDot extends StatelessWidget {
  final FeatureItem feature;
  final VoidCallback onTap;

  const FeatureDot({
    Key? key,
    required this.feature,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: feature.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 3),
              spreadRadius: 1,
            ),
          ],
        ),
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: () {
            onTap();
          },
          child: SizedBox(
            width: 70,
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature.icon,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(height: 4),
                Text(
                  feature.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w200,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}