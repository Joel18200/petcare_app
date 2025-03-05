import 'package:flutter/material.dart';
import '../utils/map_utils.dart'; // Import the map utility

class NearbyStoresScreen extends StatelessWidget {
  const NearbyStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Vet & Grooming Centers")),
      body: ListView(
        children: const [
          StoreCard(
            name: "Vet Hospitals",
            placeName: "RED VETS PET CLINIC ADOOR, ADOOR", // Pass the exact store name
            imageUrl:
            "https://static.vecteezy.com/system/resources/previews/047/784/272/non_2x/a-cartoon-illustration-depicting-a-hospital-building-in-a-city-with-two-ambulances-parked-outside-the-sky-is-blue-with-white-clouds-free-vector.jpg",
          ),
          StoreCard(
            name: "Grooming Hub",
            placeName: "Handz N Pawz Karunagappally , Karunagappally", // Different store location
            imageUrl:
            "https://media.istockphoto.com/id/1405431897/vector/shaggy-dog.jpg?s=612x612&w=0&k=20&c=pyrubEzEkbly7lay_L6L05ACim5G-TXajgy2Wxgpy5A=",
          ),
        ],
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final String name;
  final String placeName; // Now accepts a store name instead of lat/lng
  final String imageUrl;

  const StoreCard({
    super.key,
    required this.name,
    required this.placeName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MapUtils.openGoogleMaps(placeName); // Pass the store name dynamically
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
