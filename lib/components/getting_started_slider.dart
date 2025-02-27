import 'package:flutter/material.dart';
import 'package:pawfect/utils/constants.dart';

class GettingStartedSlider extends StatelessWidget {
  const GettingStartedSlider({required this.isOn, super.key});

  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600), // Set the duration of the animation
        curve: Curves.easeInOut, // Smooth easing curve for the transition
        width: 18,
        height: 7,
        decoration: BoxDecoration(
          color: isOn ? greenColor : primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: greenColor,
            width: isOn ? 0 : 1,
          ),
        ),
      ),
    );
  }
}
