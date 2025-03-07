import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetDashboard extends StatelessWidget {
  const PetDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            Text("Hey Pixel Posse,", style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white)),
            const Spacer(),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual asset
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMyPetsSection(),
            const SizedBox(height: 16),
            _buildPetLocationAndStatus(),
            const SizedBox(height: 16),
            _buildPetFoodSection(),
            const SizedBox(height: 16),
            _buildVetsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPetsSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🐾 My Pets", style: _sectionTitleStyle()),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _petAvatar("Bella", "assets/dog1.jpg", Colors.orange),
              _petAvatar("Roudy", "assets/dog2.jpg", Colors.blue),
              _petAvatar("Furry", "assets/dog3.jpg", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _petAvatar(String name, String imagePath, Color color) {
    return Column(
      children: [
        CircleAvatar(radius: 35, backgroundColor: color, backgroundImage: AssetImage(imagePath)),
        const SizedBox(height: 5),
        Text(name, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPetLocationAndStatus() {
    return Row(
      children: [
        Expanded(
          child: _sectionContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📍 Pet Location", style: _sectionTitleStyle()),
                const SizedBox(height: 8),
                Image.asset('assets/map.jpg', height: 80), // Placeholder for map
                TextButton(onPressed: () {}, child: Text("Track Pets", style: GoogleFonts.fredoka())),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _sectionContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📊 Pet Status", style: _sectionTitleStyle()),
                _statusRow("Bella", 88, 48, 51),
                _statusRow("Roudy", 78, 65, 42),
                _statusRow("Furry", 89, 46, 91),
                TextButton(onPressed: () {}, child: Text("Check Pets", style: GoogleFonts.fredoka())),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusRow(String name, int health, int food, int mood) {
    return Row(
      children: [
        const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/dog1.jpg')),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 14)),
            Row(
              children: [
                _statusBar(health, Colors.green),
                _statusBar(food, Colors.orange),
                _statusBar(mood, Colors.red),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusBar(int value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      height: 6,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color.withOpacity(value / 100),
      ),
    );
  }

  Widget _buildPetFoodSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🍖 Pet Food", style: _sectionTitleStyle()),
          _foodItem("Josera", "Josi Dog Master Mix", "900g", "assets/food1.jpg"),
          _foodItem("Happy Pet", "Happy Dog - Profi Line High Energy", "500g", "assets/food2.jpg"),
        ],
      ),
    );
  }

  Widget _foodItem(String brand, String name, String weight, String imagePath) {
    return ListTile(
      leading: Image.asset(imagePath, width: 40),
      title: Text(name, style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text("$brand - $weight", style: GoogleFonts.fredoka(fontSize: 12)),
      trailing: const Icon(Icons.shopping_cart),
    );
  }

  Widget _buildVetsSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🐶 Vets", style: _sectionTitleStyle()),
          ListTile(
            leading: const CircleAvatar(backgroundImage: AssetImage('assets/vet.jpg')),
            title: Text("Dr. Nambuvan", style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text("Bachelor of Veterinary Science\n⭐ 5.0 (100 reviews)", style: GoogleFonts.fredoka(fontSize: 12)),
            trailing: Column(children: [
              Text("📍 2.5 km", style: GoogleFonts.fredoka(fontSize: 12)),
              Text("💰 100\$", style: GoogleFonts.fredoka(fontSize: 12)),
            ]),
          ),
          TextButton(onPressed: () {}, child: Text("Book Appointment", style: GoogleFonts.fredoka())),
        ],
      ),
    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: child,
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)],
    );
  }

  TextStyle _sectionTitleStyle() => GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.bold);
}
