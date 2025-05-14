import 'package:pawfect/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HelpDetail extends StatefulWidget {
  const HelpDetail({super.key});

  @override
  State<HelpDetail> createState() => _HelpDetailState();
}

class _HelpDetailState extends State<HelpDetail> {
  List<Widget> widget = [];

  @override
  void initState() {
    super.initState();
    for (var _ in [1, 2, 3, 4]) {
      widgets.add(Image.asset(
        starImage,
        width: 15,
        height: 15,
      ));
  }
}

@override
    Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
             onPressed: () {
              context.pop();
             },
        ),
        backgroundColor: greenColor,
        title: Text(
          "Dr.Nambuvan",
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset(
            veterinaryDoctorImage,
            height: height / 3,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. Nambuvan",
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w700,
                    fontSize: 26.27,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  "Bachelor of Veterinary Science",
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.77,
                    color: greenFiveColor,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "5.0",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: widgets,
                      ),
                    ),
                        Text(
                        "(100 reviews)",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: grayTenColor,
                        ),
                        ),
                  ],

                ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Image.asset(
                      timeImage,
                      width: 12,
                      height: 12,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Monday - Friday at 8:00am - 5:00 pm",
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: grayFiveColor,
                      ),
                    ),
                    ),
                    const Spacer(),
                    Image.asset(
                        locationImage,
                    width: 12,
                    height: 12,
                    ),
                    Padding(
                        padding: const )
                  ],
                ),)
              ],
            ),
            ),
          ),
          )
        ],
      ),
    );
    }
}