import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseAdapter {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference transactions = FirebaseFirestore.instance.collection("transactions");



}