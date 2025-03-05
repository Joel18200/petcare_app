
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class ProfileStatusItem extends StatelessWidget {
  const ProfileStatusItem(
  {
    required this.color,
  required this.imageName,
  required this.firstTitle,
  required this.secondTitle,
  required this.thirdTitle,
    required this.buttonText,
    required this.callback,
super.key});

  final Color color;
  final String imageName,firstTitle,secondTitle,thirdTitle,buttonText;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 20,
              child: SvgPicture.asset(imageName),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstTitle,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.normal,
                        fontSize: 8,
                        color: blackColor,
                      ),
                    ),
                    Text(
                      secondTitle,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.normal,
                        fontSize: 8,
                        color: blackColor,
                      ),
                    ),
                    Text(
                      thirdTitle,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.normal,
                        fontSize: 8,
                        color: greenColor,
                      ),
                    ),
                  ],
                ),
            ),
            const Spacer(),
            TextButton(
                onPressed: callback,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            buttonText,
                            style: GoogleFonts.fredoka(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Theme.of(context).primaryColor
                            ),
                          ),
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
            )
          ],
        ),
    );
  }
}