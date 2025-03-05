import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/help/help_header_item.dart';
import 'package:pawfect/help/help_list_card_item.dart';
import 'package:pawfect/help/help_list_header_item.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:pawfect/help/help_row_image_text.dart';
import 'package:pawfect/help_detail/help_detail_screen.dart';
import 'package:pawfect/utils/constants.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {}, // IconButton
        ),
        backgroundColor: greenColor, // AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // EdgeInsets.symmetric
        child: Column(
          children: [
            Text(
              howMayIHelpYou,
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Theme.of(context).primaryColorDark,
              ), // Text
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: HelpHeaderItem(
                          image: veterinaryImage,
                          title:veterinary,
                        ), // HelpHeaderItem
                      ),
                      Expanded(
                        child: HelpHeaderItem(
                          image: groomingImage,
                          title: grooming,
                        ), // HelpHeaderItem
                      ),
                      Expanded(
                        child: HelpHeaderItem(
                          image: boardingImage,
                          title: boarding,
                        ), // HelpHeaderItem
                      ),
                    ],
                  ), // Row
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColorDark,
              thickness: 1,
            ), // Divider
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: HelpListHeaderItem(
                          title: 'Nearby Veterinarian',
                        ), // HelpListHeaderItem
                      ),
                      Column(
                        children: [1, 2, 3, 4].map((e) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: HelpListCardItem(),
                        ))
                            .toList(), // HelpListCardItem
                      ),
                    ],
                  );
                },
                itemCount: 10,
              ), // ListView.builder
            ),
          ],
        ), // Column
      ), // Padding
    ); // Scaffold
  }
}