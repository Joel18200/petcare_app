import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/profile/profile_about.dart';
import 'package:pawfect/profile/profile_card_item.dart';
import 'package:pawfect/profile/profile_name.dart';
import 'package:pawfect/profile/profile_status_item.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:pawfect/components/login_textfield.dart';
import 'package:pawfect/components/simple_button.dart';
import 'package:pawfect/components/petcare_button.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  profileBackImage,
                  width: double.infinity,
                  height: 341,
                ),
                const ProfileName(),
                const ProfileAbout(
                  image: petProfileImage,
                  name: "About Bella"
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: ProfileCardItem(
                              title: age,
                              subTitle: "1y 4n 11d",
                            ),
                        ),
                        Expanded(
                          child: ProfileCardItem(
                              title: weight,
                              subTitle: "7.5 kg",
                          ),
                        ),
                        Expanded(
                          child: ProfileCardItem(
                              title: height,
                              subTitle: "54 cm"
                          ),
                        ),
                        Expanded(
                          child: ProfileCardItem(
                              title: color,
                              subTitle: "Black"
                          ),
                        ),
                      ],
                    ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                child: Text(
                  "My first dog which was gifted by my mother for my 20th birthday",
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                    color: blackColor,
                  ),
                ),
                ),
                const ProfileAbout(
                  image: smileysImage,
                  name: "Bella's Status",
                ),
                ProfileStatusItem(
                  color: redColor,
                  imageName: healthImage,
                  firstTitle: health,
                  secondTitle: abnormal,
                  thirdTitle: lastVaccinated,
                  buttonText: contactVet,
                  callback: () => {context.pushNamed(petHealthRoute)},
                ),
            ProfileStatusItem(
                color: greenColor,
                imageName: foodImage,
                firstTitle: food,
                secondTitle: hungry,
                thirdTitle: lastFed,
                buttonText: checkFood,
                callback: () => {context.pushNamed(petHealthRoute)},
          ),
             ProfileStatusItem(
                color: redColor,
                imageName: moodImage,
                firstTitle: mood,
                secondTitle: abnormal,
                thirdTitle: lastVaccinated,
                buttonText: whistle,
                callback: () => {context.pushNamed(petHealthRoute)},
      ),
              ],
            ),
          ) ),
    );
  }
}