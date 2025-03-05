import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/pet_health/pet_health_medical_records.dart';
import 'package:pawfect/pet_health/pet_health_wellness.dart';
import 'package:pawfect/utils/constants.dart';

class PetHealth extends StatelessWidget {
  const PetHealth({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2 ,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
                labelStyle: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor),
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: wellness),
                  Tab(
                    text: medicalRecords,
                  )
                ]
            ),
            backgroundColor: greenColor,
            title: Text(
              petHealth,
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                color: Theme.of(context).primaryColor),
              ),
            ),
          body: const TabBarView(children: [
            PetHealthWellness(),
            PetHealthMedicalRecords(),
          ]),
          ),
        );
  }
}