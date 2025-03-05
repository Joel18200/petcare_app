import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class PetHealthBodyCard extends StatelessWidget {
  const PetHealthBodyCard({
    required this.firstTitle,
    required this.secondTitle,
    required this.thirdTitle,
    super.key,
  });

  final String firstTitle, secondTitle, thirdTitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shadowColor: grayFourColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric( // 🔹 Add padding inside card
            vertical: 16, // Increased top & bottom padding
            horizontal: 12, // Added left & right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 🔹 Aligns text to left
            children: [
              Text(
                firstTitle,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w700,
                  fontSize: 16, // 🔹 Slightly increased size
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 6), // 🔹 Adds spacing between lines
              Text(
                secondTitle,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                thirdTitle,
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
