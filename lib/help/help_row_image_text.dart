import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class HelpRowImageText  extends StatelessWidget{
  const HelpRowImageText(
      {required this.image,
        required this.text,
        required this.width,
        required this.height,
        super.key});

  final String image, text;
  final double width, height;

  @override
    Widget build(BuildContext context)  {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(
              image,
              width: width,
              height: height,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  text,
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    color: grayEightColor),
                  ),
                ),
          ],
        )
      ],
    );
  }
  }
