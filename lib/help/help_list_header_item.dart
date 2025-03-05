import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class HelpListHeaderItem extends StatelessWidget{
  const HelpListHeaderItem({required this.title,super.key});

  final String title;

  @override
    Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.fredoka(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Theme
                  .of(context)
                  .primaryColor),
        ),
        const Spacer(),
        Text(
          seeAll,
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w300,
            fontSize: 15,
            color: grayFiveColor,
          ),
        )
      ],
    );
  }
  }
