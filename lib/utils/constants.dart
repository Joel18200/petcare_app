import 'dart:ui';
import 'package:flutter/scheduler.dart';
//routes
const gettingStartedRoute = '/gettingStarted';
const loginRoute = '/loginRoute';
const dashboardRoute = '/dashboardRoute';
const signupRoute = '/signupRoute';
const petHealthRoute = '/petHealthRoute';
const helpRoute = '/helpRoute';
const helpDetailRoute = '/helpDetailRoute';


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
const foodImage = 'images/food.svg';
const healthImage = 'images/health.svg';
const genderImage = 'images/gender.svg';
const moodImage = 'images/mood.svg';
const profileBackImage = 'images/profile.webp';
const petProfileImage = 'images/pet_profile.svg';
const smileysImage = 'images/smileys.svg';
const pawImage = 'images/pet.webp';
const home2Image = 'images/home.webp';
const discover2Image = 'images/discover.webp';
const reminder2Image = 'images/reminder.webp';
const shopping2Image = 'images/shopping.webp';
const petProfile2Image = 'images/pet2.webp';
const bigNextImage = 'images/big_next.svg';
const boardingImage = 'images/boarding.webp';
const groomingImage = 'images/grooming.webp';
const veterinaryImage = 'images/veterinary.webp';
const vetImage = 'images/vet.webp';
const starImage = 'images/star.webp';
const locationImage = 'images/location.webp';
const priceImage = 'images/price.webp';
const timeImage = 'images/time.webp';
const veterinaryDoctorImage = 'images/veterinary_doctor.webp';

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
const grayFourColor = Color(0xFFC9C9C9);
const grayFiveColor = Color(0xFFA6A6A6);
const graySixColor = Color(0xFFE5E5E5);
const graySevenColor = Color(0xFFd9d9d9);
const grayEightColor = Color(0xFFA6A6A6);
const grayNineColor = Color(0xFF5F5F63);
const grayTenColor = Color(0xFF868889);
const greenTwoColor = Color(0xFF327030);
const greenThreeColor = Color(0xFF064E57);
const greenFourColor = Color(0xFFd1e9d1);
const greenFiveColor = Color(0xFF064E57);
const blackColor = Color(0xFF32323D);
const redColor = Color(0xFFE54D4D);
const blueColor = Color(0xFF3B738F);
const blueTwoColor = Color(0xFF5AB197);
const blueThreeColor = Color(0xFF7AB6AE);

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
const name = 'Enter Your Full Name';
const emailAddress = 'Email Address';
const password = 'Password';
const confirmPassword = 'Confirm Password';
const forgotPassword = 'Forget Password?';
const loginWithGoogle   = 'Login With Google';
const loginWithFacebook = 'Login With Facebook';
const loginWithApple    = 'Login With Apple';
const orConnectWith = 'or connect with';
const copyRightText = 'Ⓒ All Rights Reserved to Pawfect';
const donHaveAnAccount = "Don't have an account?";
const signUp = 'Sign Up';
const home = 'Home';
const discover = 'Discover';
const explore = 'Explore';
const manage = 'Manage';
const profile = 'Profile';
const somethingWentWrong = 'Something went wrong';
const ok  ="Ok";
const age = 'Age';
const height = 'Height';
const weight = 'Weight';
const color = 'Color';
const health = 'Health';
const abnormal = 'Abnormal';
const lastVaccinated = 'Last Vaccinated (2mon Ago)';
const food = 'Food';
const hungry = 'Hungry';
const lastFed = 'Last fed (1h Ago)';
const mood = 'Mood';
const whistle = 'Whistle';
const checkFood = 'Check Food';
const contactVet = 'Contact Vet';
const reminder = 'Reminder';
const shopping = 'Shopping';
const petHealth = 'Pet Health';
const wellness = 'Wellness';
const medicalRecords = 'Medical Records';
 const vaccinations = 'Vaccinations';
const seeAllText = 'See all';
const appointments = 'Appointments';
const scheduleAppointment =
    "When you schedule an appointment, you'll see it here. Let's set your first appointment." ;
const start = 'Start';
const pastTreatments = 'Past Treatments';
const howMayIHelpYou = 'Hello, How may I help you ?';
const veterinary = 'Veterinary';
const grooming = 'Grooming';
const boarding = 'Boarding';
const seeAll = 'See all';
const bookAnAppointment = 'Book an Appointment';

//Errors
const emailError = 'Invalid email Id';
const passwordError = 'Invalid password';

