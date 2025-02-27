import 'dart:ui';
import 'package:flutter/scheduler.dart';
//routes
const gettingStartedRoute = '/gettingStarted';
const loginRoute = '/loginRoute';
const dashboardRoute = '/dashboardRoute';

//images
const dogOneImage = 'images/dog_one.webp';
const dogTwoImage = 'images/dog_two.webp';
const nextImage = 'images/next.webp';
const cocoImage = 'images/coco.webp';
const appleImage = 'images/apple.svg';
const googleImage = 'images/google.svg';
const facebookImage = 'images/facebook.svg';
const cocoLoginImage = 'images/coco_login.svg';
const lockImage = 'images/lock.svg';
const mailImage = 'images/mail.svg';
const loginBackgroundImage = 'images/login_bg.webp';
const discoverImage = 'images/discover.svg';
const manageImage = 'images/manage.svg';
const exploreImage = 'images/explore.svg';
const homeImage = 'images/home.svg';
const profileImage = 'images/profile.svg';

var brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;
bool isDarkMode = brightness == Brightness.light;

//color
Color backgroundColor =
    isDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
Color primaryColor =
    isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
const grayColor = Color(0xFFA1A1A1);
const greenColor = Color(0xFF5CB15A);
const grayTwoColor = Color(0xFFD4D4D4);
const grayThreeColor = Color(0xFF747070);
const greenTwoColor = Color(0xFF327030);

//Constants
const heyWelcome = 'Hey! Welcome';
const now ='Now !';
const weProvide = 'We Provide';
const next = 'Next';
const descriptionOne = 'while you sit and stay - we\'ll go\nout and play';
const descriptionTwo =
    'One tap for foods,acessories,health care products & digital gadgets\n\nGrooming & boarding\n\nEasy & best consultation bookings';
const descriptionThree =
    '24hrs location tracking & health\nupdates\n\nOn time feeding\nupdates';
const getStarted = 'Get Started';
const alreadyHaveAnAccount = 'Already have an account?';
const login = 'Login';
const emailAddress = 'Email Address';
const password = 'Password';
const forgotPassword = 'Forget Password?';
const loginWithGoogle   = 'Login With Google';
const loginWithFacebook = 'Login With Facebook';
const loginWithApple    = 'Login With Apple';
const orConnectWith = 'or connect with';
const copyRightText = 'Ⓒ All Rights Reserved to Pixel Posse - 2022';
const donHaveAnAccount = "Don't have an account?";
const signUp = 'Sign Up';
const home = 'Home';
const discover = 'Discover';
const explore = 'Explore';
const manage = 'Manage';
const profile = 'Profile';
