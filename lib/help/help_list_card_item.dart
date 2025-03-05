import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:pawfect/help/help_row_image_text.dart';

class HelpListCardItem extends StatefulWidget {
  const HelpListCardItem({super.key});

  @override
  State<HelpListCardItem> createState() => _HelpListCardItemState();
}

class _HelpListCardItemState extends State<HelpListCardItem> {
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    for(var _ in [1, 2, 3, 4]) {
      widgets.add(Image.asset(
        starImage,
        width: 15,
          height: 15,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(helpDetailRoute);
      },
      child: Card(
        shadowColor: graySixColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: graySevenColor,
            width: 1,
          )
        ),
        elevation: 4,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                    flex: 2,
                    child: Image.asset(
                      vetImage,
                    ),
                ),
                Flexible(
                  flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. Sambuvan",
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          "Veterinary Dentist",
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: grayEightColor,
                          ),
                        ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: widgets,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "5.0 {100 reviews}",
                              style: GoogleFonts.fredoka(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            )
                          ],
                        )
                      ],
                    ),
                    ),
                )
              ],
            ),
            Padding(
                padding:const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "4 years of experience",
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: grayEightColor,
                      ),
                    ),
                    const Spacer(),
                    const HelpRowImageText(
                        image: locationImage ,
                        text: "2 km",
                        width: 10,
                        height: 10,
                    ),
                    const Spacer(),
                    const HelpRowImageText(
                      image: priceImage ,
                      text: "120\$",
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
            ),
            const HelpRowImageText(
              image: timeImage,
              text: "Monday - Friday at 8.00 am - 5.00 pm",
              width: 12,
              height: 12,
            ),
          ],
        ),),
      ),
    );
  }
}