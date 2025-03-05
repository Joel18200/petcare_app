import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class HelpHeaderItem extends StatelessWidget{
  const HelpHeaderItem({required this.image,required this.title,super.key});

  final String image, title;

  @override
  Widget build(BuildContext context)  {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: blueTwoColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            image,
            width: 31,
            height: 31,
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8),
        child: Text(
          title,
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w300,
            fontSize: 15,
          ),
        ),)
      ],
    );
  }
}
