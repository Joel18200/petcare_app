import 'package:flutter/material.dart';
import 'package:pawfect/pet_health/pet_health_body_card.dart';
import 'package:pawfect/pet_health/pet_health_title.dart';
import 'package:pawfect/utils/constants.dart';

class PetHealthCard extends StatelessWidget {
  const PetHealthCard({
    required this.title,
    required this.seeAll,
    required this.titles,
    super.key,
  });

  final String title;
  final bool seeAll;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    // Debugging: Print the length of the titles list
    print("PetHealthCard - Title: $title, Titles List Length: ${titles.length}");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Card(
        shadowColor: grayFourColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PetHealthTitle(
                  title: title,
                  seeAll: seeAll,
                ),
              ),
              Row(
                children: [
                  // First PetHealthBodyCard (Checks for at least 3 items)
                  if (titles.length >= 3)
                    PetHealthBodyCard(
                      firstTitle: titles[0],
                      secondTitle: titles[1],
                      thirdTitle: titles[2],
                    ),

                  const SizedBox(width: 20),

                  // Second PetHealthBodyCard (Checks for at least 6 items)
                  if (titles.length >= 6)
                    PetHealthBodyCard(
                      firstTitle: titles[3],
                      secondTitle: titles[4],
                      thirdTitle: titles[5],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
