
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';


class PetCareButton extends StatelessWidget {
  const PetCareButton({required this.icon, required this.text,super.key});
  
  final String icon, text;
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    text,
                    style: GoogleFonts.fredoka(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
              )
            ],
          ),
        )
    );
  }
}