import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<void> populateMessDB() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('messTimetables').get();
  for (var doc in snapshot.docs) {
    await doc.reference.delete();
  }

  final String response = await rootBundle.loadString('assets/mess.json');
  final data = await json.decode(response);
  data.forEach((element) async {
    // print(element);
    var res = await FirebaseFirestore.instance
        .collection('messTimetables')
        .add(element);
    print(res);
  });
}

Future<void> populateAmenitiesDB() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('amenities').get();
  for (var doc in snapshot.docs) {
    await doc.reference.delete();
  }

  final String response = await rootBundle.loadString('assets/amenities.json');
  final data = await json.decode(response);
  data.forEach((element) async {
    await FirebaseFirestore.instance.collection('amenities').add(element);
  });
}
