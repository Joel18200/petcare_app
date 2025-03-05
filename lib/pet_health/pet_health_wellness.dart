import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/pet_health/pet_health_title.dart';
import 'package:pawfect/pet_health/pet_health_card.dart';
import 'package:pawfect/utils/constants.dart';


class PetHealthWellness extends StatelessWidget {
  const PetHealthWellness({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      children: [
        const PetHealthCard(
          title: "Vaccinations",
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
        const PetHealthCard(
          title:"Allergies" ,
          seeAll: true,
          titles: [
            "Skin Allergies",
            "May be accompanied by ",
            "gastrointestinal symptoms.",
            "Dr. Jerry",
            "Food Allergies",
                "May be accompanied by",
            "gastrointestinal symptoms.",
          ],
        ),
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
    child: Card(
    shadowColor: grayFourColor,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
    side: BorderSide(
    color: Theme.of(context).primaryColor.withOpacity(0.3),
    ),
    ),
    child: Padding( // 👈 Added padding here to give space inside the card
    padding: const EdgeInsets.all(12),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center, // 👈 Center content horizontally
    children: [
    const Padding(
    padding: EdgeInsets.only(bottom: 5),
    child: PetHealthTitle(
    title: appointments,
    seeAll: false,
    ),
    ),
    Padding( // 👈 Add padding around the text to prevent touching edges
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
    scheduleAppointment,
    textAlign: TextAlign.center, // 👈 Center text if needed
    style: GoogleFonts.fredoka(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: Theme.of(context).primaryColor,
    ),
    ),
    ),
    Padding( // 👈 Added padding to TextButton to create space
    padding: const EdgeInsets.only(top: 8),
    child: TextButton(
    onPressed: () {},
    child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
    decoration: BoxDecoration(
    color: greenColor,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
    color: Theme.of(context).primaryColor,
    ),
    ),
    child: Text(
    start,
    style: GoogleFonts.fredoka(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Theme.of(context).primaryColor,
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),
    );
  }
}
