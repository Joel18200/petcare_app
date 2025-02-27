import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class SimpleButton extends StatelessWidget{
  const SimpleButton({required this.callback, required this.text,super.key});

  final VoidCallback callback;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: callback,
        child: Text(
          text,
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: greenColor,
          ),
        ),
    );
  }
}