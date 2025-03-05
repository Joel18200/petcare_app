import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/signup/signup.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:pawfect/components/login_textfield.dart';
import 'package:pawfect/components/simple_button.dart';
import 'package:pawfect/components/petcare_button.dart';
import 'package:go_router/go_router.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            loginBackgroundImage,
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  const Spacer(),
                  Image.asset(
                    cocoImage,
                    width: 240,
                    height: 240,
                  ),
                  const Spacer()
                ],
              ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 25),
                decoration: const BoxDecoration(
                  color: greenColor,
                ),
                alignment: Alignment.center,
                child: SafeArea(
                    bottom: true,
                    left: false,
                    right: false,
                    top: false,
                    child: Text(
                      copyRightText,
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ),
              ),
          ),
          SafeArea(
              child: Padding(
                  padding: const EdgeInsets.only(top: 210, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LoginTextField(
                        labelText: emailAddress,
                        textInputType: TextInputType.emailAddress,
                        focusNode: emailFocusNode,
                        nextFocusNode: passwordFocusNode,
                        isLast: false,
                        onChanged: (value) {},
                        icon: mailImage,
                        obscureText: false,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: LoginTextField(
                            labelText: password,
                            textInputType: TextInputType.emailAddress,
                            focusNode: passwordFocusNode,
                            nextFocusNode: null,
                            isLast: true,
                            onChanged: (value) {},
                            icon: lockImage,
                            obscureText: true,
                        ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        SimpleButton(
                            callback: () {},
                            text: forgotPassword,
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 4,bottom: 12),
                        child: Text(
                          orConnectWith,
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.normal,
                            fontSize: 25,
                            color: grayThreeColor,
                          ),
                        ),
                    ),
                    const PetCareButton(
                        icon: googleImage,
                        text: loginWithGoogle,
                    ),

                    const PetCareButton(
                      icon: facebookImage,
                      text: loginWithFacebook,
                    ),
                    const PetCareButton(
                      icon: appleImage,
                      text: loginWithApple,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          donHaveAnAccount,
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: grayThreeColor,
                          ),
                        ),
                        const SizedBox(width: 1), // Adjust spacing as needed
                        SimpleButton(
                          callback: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const Signup(),
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
                          text: signUp,
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              )
          )
        ],
      ),
    );
  }
}
