import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/pet_health/pet_health_body_card.dart';
import 'package:pawfect/pet_health/pet_health_title.dart';
import 'package:pawfect/pet_health/pet_health_card.dart';
import 'package:pawfect/utils/constants.dart';

class PetHealthMedicalRecords extends StatelessWidget {
  const PetHealthMedicalRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      const PetHealthCard(
      title: "Past vaccinations",
      seeAll: true,
      titles: [
        "Rabies vaccination",
        "24th Jan 2022",
        "Dr. Nambuvan",
        "Calicivirus",
        "12th Feb 2022",
        "Dr. Raam"
      ],
    ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shadowColor: grayFourColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                )
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                  child: PetHealthTitle(
                      title: pastTreatments ,
                    seeAll: false,
                  ),
                  ),
                  Padding(
                      padding:const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Allergies",
                    style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  ),
                  Row(
                    children: [
                      const PetHealthBodyCard(
                          firstTitle: "Skin Allergies",
                          secondTitle: "Wed 13 Mar",
                          thirdTitle: "Dr. Jerry"),
                      const SizedBox(
                        width: 20,
                      ),
                      const PetHealthBodyCard(
                          firstTitle: "Skin Allergies",
                          secondTitle: "Thu 14 Mar",
                          thirdTitle: "Dr. Klein"),
                      const SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset(bigNextImage)
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Cough",
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                  ),
                  Row(
                    children: [
                      const PetHealthBodyCard(
                          firstTitle: "Skin Allergies",
                          secondTitle: "Wed 13 Mar",
                          thirdTitle: "Dr. Jerry"
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const PetHealthBodyCard(
                          firstTitle: "Skin Allergies",
                          secondTitle: "Thu 14 Apr",
                          thirdTitle: "Dr. Klein"
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset(
                        bigNextImage,
                      )
                    ],
                  )
                ],
              ),
              ),
            ),
        ),
    ],
    );
  }
}

