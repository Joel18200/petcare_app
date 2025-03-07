import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/profile/profile.dart';
import 'package:pawfect/reminder/reminder_page.dart';
import 'package:pawfect/screens/home/pet_dashboard.dart';
import 'package:pawfect/utils/amazoncard.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:pawfect/screens/nearby_stores.dart';
import 'package:url_launcher/url_launcher.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Test function to check if URL can be launched
  Future<void> testUrlLauncher() async {
    final Uri testUrl = Uri.parse("https://flutter.dev");

    if (await canLaunchUrl(testUrl)) {
      await launchUrl(testUrl, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open the website.");
    }
  }

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const PetDashboard(),
    const NearbyStoresScreen(),
    AmazonCard(),
    const ReminderPage(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: greenColor.withOpacity(0.8),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Highlight selected item with blue color
        unselectedItemColor: Colors.white, // Color for unselected items
        selectedLabelStyle: GoogleFonts.fredoka(
          fontWeight: FontWeight.normal,
          fontSize: 9,
          color: Colors.blue, // Color for selected label
        ),
        unselectedLabelStyle: GoogleFonts.fredoka(
          fontWeight: FontWeight.normal,
          fontSize: 9,
          color: Colors.white, // Color for unselected label
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.blue, // Color for selected icon
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white, // Color for unselected icon
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(homeImage, height: 25, width: 25),
            label: home,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(discoverImage, height: 25, width: 25),
            label: discover,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(exploreImage, height: 25, width: 25),
            label: shopping,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(manageImage, height: 25, width: 25),
            label: reminder,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(profileImage, height: 25, width: 25),
            label: profile,
          ),
        ],
      ),
    );
  }
}