import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Text('Index 0: Home'),
    const Text('Index 1: Discover'),
    const Text('Index 2: Explore'),
    const Text('Index 3: Manage'),
    const Text('Index 4: Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Added Center to align content properly
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: greenColor.withOpacity(0.8),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Ensure this updates correctly
        onTap: _onItemTapped, // Connect onTap to function
        selectedLabelStyle: GoogleFonts.fredoka(
          fontWeight: FontWeight.normal,
          fontSize: 9,
          color: Theme.of(context).primaryColor,
        ),
        unselectedLabelStyle: GoogleFonts.fredoka(
          fontWeight: FontWeight.normal,
          fontSize: 9,
          color: Theme.of(context).primaryColor,
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
            label: explore,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(manageImage, height: 25, width: 25),
            label: manage,
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
