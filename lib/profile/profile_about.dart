import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class ProfileAbout extends StatelessWidget {
  const ProfileAbout({required this.name,required this.image,super.key});

  final String name,image;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:const EdgeInsets.all(0),
        child: Row(
          children: [
            SvgPicture.asset(image),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  name,
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.7,
                    color: primaryColor,
                  ),
                ),
            ),
          ],
        ),
    );
  }
}