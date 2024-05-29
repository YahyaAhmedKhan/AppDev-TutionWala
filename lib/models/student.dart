import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/review.dart';

class Student {
  String? accountRef;
  final String availability;
  final List<Contract> contracts;
  final String firstName;
  final String lastName;
  final List<String> subjects;

  Student({
    this.accountRef,
    required this.availability,
    required this.contracts,
    required this.firstName,
    required this.lastName,
    required this.subjects,
  });
  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Student.fromJson(data);
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      accountRef: json['accountRef'] as String,
      availability: json['availability'] as String,
      contracts: (json['contracts'] as List<dynamic>)
          .map(
              (contract) => Contract.fromJson(contract as Map<String, dynamic>))
          .toList(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      subjects: (json['subjects'] as List<dynamic>)
          .map((subject) => subject as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountRef': accountRef,
      'availability': availability,
      'contracts': contracts.map((contract) => contract.toJson()).toList(),
      'firstName': firstName,
      'lastName': lastName,
      'subjects': subjects,
    };
  }
}
