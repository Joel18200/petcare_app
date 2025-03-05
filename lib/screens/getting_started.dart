
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/login/login.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:pawfect/components/getting_started_slider.dart';

class GettingStarted extends StatefulWidget{
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted>{
  int pageNumber = 1;
  String title = heyWelcome;
  String description = descriptionOne;
  String buttonTitle = next;
  String backgroundImage = dogOneImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            backgroundImage,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              const Spacer(),
              Container(
                padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GettingStartedSlider(
                                isOn: pageNumber == 1 ? true : false,
                            ),
                            GettingStartedSlider(
                              isOn: pageNumber == 2 ? true : false,
                            ),
                            GettingStartedSlider(
                              isOn: pageNumber == 3 ? true : false,
                            )
                          ],
                        ),
                    ),
                    pageNumber == 1
                        ? Image.asset(
                            cocoImage,
                            width: 98,
                            height: 93,
                          )
                        : const SizedBox(),
                    Text(
                      title,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          description,
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                            color: grayColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(greenColor),
                        ),
                        onPressed: () {
                          setState(() {
                            if (pageNumber < 3) {
                              pageNumber += 1;
                              if (pageNumber == 2) {
                                title = now;
                                description = descriptionTwo;
                                backgroundImage = dogTwoImage;
                              } else {
                                title = weProvide;
                                description = descriptionThree;
                                buttonTitle = getStarted;
                                backgroundImage = nextImage;
                              }
                            } else {
                              // Navigate to the login page when on the last page
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const Login(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0, 1.0); // Start from bottom
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 1000),
                                ),
                              );
                            }
                          });
                        },

                        child: Row(
                          children: [
                            const Spacer(),
                            Text(
                              buttonTitle,
                              style: GoogleFonts.fredoka(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: primaryColor,
                              ),
                            ),
                            const Spacer(),
                            SvgPicture.asset(nextImage),
                          ],
                        ),
                      ),
                    ),
                    pageNumber == 3
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          alreadyHaveAnAccount,
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: primaryColor),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const Login(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0); // Start from bottom
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 1000),
                                  ),
                                );
                              },
                              child: Text(
                                login,
                                style: GoogleFonts.fredoka(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: greenColor,
                                ),
                              )
                          )

                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}