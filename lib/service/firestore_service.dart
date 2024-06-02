import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/student.dart';
import 'package:tution_wala/models/tutor.dart';

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

      if (querySnapshot.docs.isEmpty)
        throw Exception("$email not found in user-roles collection");

      DocumentSnapshot doc = querySnapshot.docs.first;
      return doc['role'];
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  Future<DocumentSnapshot> getAccountSnapshotById(String docId) async {
    CollectionReference accountsCollection =
        _firebaseFirestore.collection("accounts");

    DocumentSnapshot documentSnapshot =
        await accountsCollection.doc(docId).get();
    return documentSnapshot;
  }

  Future<DocumentSnapshot> getStudentById(String docId) async {
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection('students').doc(docId).get();
    if (!documentSnapshot.exists) {
      throw Exception("Student with id:$docId does not exist");
    }
    return documentSnapshot;
  }

  Future<DocumentSnapshot> getTutorById(String docId) async {
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection('tutors').doc(docId).get();
    if (!documentSnapshot.exists) {
      throw Exception("Tutor with id:$docId does not exist");
    }
    return documentSnapshot;
  }

  Future<DocumentReference> makeStudentAccount(
      Account account, Student student) async {
    try {
      DocumentSnapshot documentSnapshot =
          await getAccountSnapshotById(account.email);
      if (documentSnapshot.exists) {
        throw Exception("Account already exists: ${documentSnapshot.id}");
      }

      return await _firebaseFirestore.runTransaction((transaction) async {
        // Create the account document using the Account object
        DocumentReference accountRef =
            _firebaseFirestore.collection("accounts").doc(account.id);

        transaction.set(accountRef, account.toJson());

        // Update the accountRef in the Student object
        student.accountRef = accountRef.id;

        // Create the student document using the Student object
        DocumentReference studentRef =
            _firebaseFirestore.collection("students").doc();

        transaction.set(studentRef, student.toJson());

        // Update account document to have studentRef of student document
        transaction.update(accountRef, {'studentRef': studentRef.id});

        return accountRef;
      });
    } catch (e) {
      // Handle any errors that occur during the transaction
      print('Transaction failed: $e');
      rethrow; // Rethrow the error after logging it
    }
  }

  Future<DocumentReference> makeTutorAccount(
      Account account, Tutor tutor) async {
    try {
      DocumentSnapshot documentSnapshot =
          await getAccountSnapshotById(account.email);
      if (documentSnapshot.exists) {
        throw Exception("Account already exists: ${documentSnapshot.id}");
      }

      return await _firebaseFirestore.runTransaction((transaction) async {
        // Create the account document using the Account object
        DocumentReference accountRef =
            _firebaseFirestore.collection("accounts").doc(account.id);

        transaction.set(accountRef, account.toJson());

        // Update the accountRef in the Tutor object
        tutor.accountRef = accountRef.id;

        // Create the tutor document using the Tutor object
        DocumentReference studentRef =
            _firebaseFirestore.collection("tutors").doc();

        transaction.set(studentRef, tutor.toJson());

        // Update account document to have tutorRef of student document
        transaction.update(accountRef, {'tutorRef': studentRef.id});

        return accountRef;
      });
    } catch (e) {
      // Handle any errors that occur during the transaction
      print('Transaction failed: $e');
      rethrow; // Rethrow the error after logging it
    }
  }

  Future<DocumentReference> addContract(Contract contract) async {
    final docRef =
        await _firebaseFirestore.collection("contracts").add(contract.toJson());
    return docRef;
  }

  Future<Stream<QuerySnapshot>> getTutors() async {
    return await _firebaseFirestore.collection("tutors").snapshots();
  }

  Future<QuerySnapshot> getPendingAcceptedContractsByStudentAndTutor(
      String studentId, String tutorId) async {
    final query = await _firebaseFirestore
        .collection("contracts")
        .where("studentRef", isEqualTo: studentId)
        .where("tutorRef", isEqualTo: tutorId)
        .where("state", whereIn: ["pending", "accepted"]).get();
    return query;
  }

  Future<void> updateStudentContracts(
      String studentRef, String contractId) async {
    final studentDoc =
        _firebaseFirestore.collection('students').doc(studentRef);
    await studentDoc.update({
      'contracts': FieldValue.arrayUnion([contractId])
    });
  }

  Future<void> updateTutorContracts(String tutorRef, String contractId) async {
    final tutorDoc = _firebaseFirestore.collection('tutors').doc(tutorRef);
    await tutorDoc.update({
      'contracts': FieldValue.arrayUnion([contractId])
    });
  }

  Future<List<String>> getContractIdsForStudent(String studentId) async {
    final DocumentSnapshot studentDoc =
        await _firebaseFirestore.collection('students').doc(studentId).get();
    final List<String> contractIds = studentDoc['contracts'].cast<String>();
    return contractIds;
  }

  Future<List<String>> getContractIdsForTutor(String tutorId) async {
    final DocumentSnapshot studentDoc =
        await _firebaseFirestore.collection('tutors').doc(tutorId).get();
    final List<String> contractIds = studentDoc['contracts'].cast<String>();
    return contractIds;
  }

  Future<List<QueryDocumentSnapshot>> getContractsByContractIds(
      List<String> contractIds) async {
    final QuerySnapshot contractsSnapshot = await _firebaseFirestore
        .collection('contracts')
        .where(FieldPath.documentId, whereIn: contractIds)
        .get();
    return contractsSnapshot.docs;
  }

  Future<void> updateContractState(String contractId, String state) async {
    final tutorDoc = _firebaseFirestore.collection('contracts').doc(contractId);
    await tutorDoc.update({'state': state});
  }
}
