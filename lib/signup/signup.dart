import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:pawfect/components/login_textfield.dart';
import 'package:pawfect/components/simple_button.dart';
import 'package:go_router/go_router.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
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
            height: MediaQuery.of(context).size.height,
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
                const Spacer(),
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
              padding: const EdgeInsets.only(top: 220, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Name Field with Default Flutter Icon
                    LoginTextField(
                      labelText: name,
                      textInputType: TextInputType.name,
                      focusNode: nameFocusNode,
                      nextFocusNode: emailFocusNode,
                      isLast: false,
                      onChanged: (value) {},
                      defaultIcon: Icons.person, // Changed to Flutter icon
                      obscureText: false,
                    ),
                    const SizedBox(height: 18),

                    // Email Field
                    LoginTextField(
                      labelText: emailAddress,
                      textInputType: TextInputType.emailAddress,
                      focusNode: emailFocusNode,
                      nextFocusNode: passwordFocusNode,
                      isLast: false,
                      onChanged: (value) {},
                      icon: mailImage, // Uses an image icon
                      obscureText: false,
                    ),
                    const SizedBox(height: 18),

                    // Password Field
                    LoginTextField(
                      labelText: password,
                      textInputType: TextInputType.text,
                      focusNode: passwordFocusNode,
                      nextFocusNode: confirmPasswordFocusNode,
                      isLast: false,
                      onChanged: (value) {},
                      icon: lockImage, // Uses an image icon
                      obscureText: true,
                    ),
                    const SizedBox(height: 18),

                    // Confirm Password Field
                    LoginTextField(
                      labelText: confirmPassword,
                      textInputType: TextInputType.text,
                      focusNode: confirmPasswordFocusNode,
                      nextFocusNode: null,
                      isLast: true,
                      onChanged: (value) {},
                      icon: lockImage, // Uses an image icon
                      obscureText: true,
                    ),
                    const SizedBox(height: 18),

                    // Sign Up Button
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
                        const SizedBox(width: 5),
                        SimpleButton(
                          callback: () {
                            context.pushNamed(dashboardRoute);
                          },
                          text: signUp,
                        ),
                      ],
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

