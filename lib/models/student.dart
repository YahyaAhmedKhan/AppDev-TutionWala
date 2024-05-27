import 'package:flutter/material.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/review.dart';

@immutable
class Student {
  final String accountRef;
  final String availability;
  final List<Contract> contracts;
  final String firstName;
  final String lastName;
  final List<String> subjects;

  const Student({
    required this.accountRef,
    required this.availability,
    required this.contracts,
    required this.firstName,
    required this.lastName,
    required this.subjects,
  });

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
