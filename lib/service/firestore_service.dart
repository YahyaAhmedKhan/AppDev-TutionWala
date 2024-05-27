import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/models/student.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirestoreService._internal();

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firebaseFirestore.collection('users').snapshots();
  }

  Future<DocumentReference?> addUserRole(String email, String role) async {
    try {
      // await _firebaseFirestore.collection('roles').add(userData);
      DocumentReference documentReference =
          await _firebaseFirestore.collection('user-roles').add({
        'email': email,
        'role': role,
      });
      return documentReference;
    } catch (e) {
      // throw Exception(e.message);
    }
  }

  Future<String?> getUserRole(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('user-roles')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return doc['role'];
      }
      return null;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  Future<DocumentSnapshot> getAccountSnapshotById(String docId) async {
    CollectionReference accountsCollection =
        _firebaseFirestore.collection("accounts");

    DocumentSnapshot documentSnapshot =
        await accountsCollection.doc(docId).get();
    return documentSnapshot;
  }

  Future<DocumentSnapshot> makeStudentAccount(
      Account account, Student student) {}
}
