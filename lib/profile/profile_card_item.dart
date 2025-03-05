import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class ProfileCardItem extends StatelessWidget {
  const ProfileCardItem(
      {required this.title, required this.subTitle, super.key});

  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: greenFourColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: blackColor,
              ),
            ),
            Text(
                subTitle,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: greenThreeColor,
                )
            )
          ],
        ),
      ),
    );
  }
}