import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PetService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String get _uid => _auth.currentUser!.uid;

  static Future<List<Map<String, dynamic>>> getPets() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('pets')
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      'name': doc['name'],
      'image': doc['image'],
      'color': Color(int.parse(doc['color'])),
    }).toList();
  }

  static Future<void> addPet(String name, String image, Color color) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('pets')
        .add({
      'name': name,
      'image': image,
      'color': color.value.toString(),
    });
  }

  static Future<void> deletePet(String id) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('pets')
        .doc(id)
        .delete();
  }
}
