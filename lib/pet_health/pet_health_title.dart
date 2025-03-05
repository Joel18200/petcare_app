import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class PetHealthTitle extends StatelessWidget {
  const PetHealthTitle({required this.title, required this.seeAll, super.key});

  final String title;
  final bool seeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const Spacer(),
        seeAll
             ? Text(
          seeAllText,
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: blueColor,
          ),
        )
            :const SizedBox(),
        seeAll ? const Icon(Icons.navigate_next) : const SizedBox()
  ],
    );
  }
}