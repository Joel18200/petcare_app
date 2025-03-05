import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class ProfileName extends StatelessWidget {
  const ProfileName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
           color: backgroundColor,
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
                children: [
                  Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "Bella",
                          style: GoogleFonts.fredoka(
                           fontWeight: FontWeight.bold,
                           fontSize: 26.27,
                           color: primaryColor,
    ),
    ),
                       Text(
                         "Border Collie",
                         style: GoogleFonts.fredoka(
                           fontWeight: FontWeight.normal,
                           fontSize: 20,
                           color: primaryColor,
                         ),
                       ),

                     ],
    ),
                  const Spacer(),
                  SvgPicture.asset(genderImage)
    ],
    ),
    ),
    ),
    );
  }
}