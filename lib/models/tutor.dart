import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/review.dart';
import 'package:tution_wala/providers/tutors_provider.dart';

class Tutor {
  String? accountRef;
  final String availability;
  final List<String> contracts;
  final String firstName;
  final String lastName;
  final List<String> subjects;
  final List<String> days;
  final double hourlyRate;
  double? rating;
  String? description;
  String? id;
  String? imageUrl;

  Tutor(
      {this.accountRef,
      required this.availability,
      required this.contracts,
      required this.firstName,
      required this.lastName,
      required this.subjects,
      required this.days,
      required this.hourlyRate,
      this.description,
      this.imageUrl,
      this.rating});

  factory Tutor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Tutor tutor = Tutor.fromJson(data);
    tutor.id = doc.id;
    return tutor;
  }

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      accountRef: json['accountRef'] as String?,
      availability: json['availability'] as String,
      contracts: (json['contracts'] as List<dynamic>)
          .map((contract) => contract.toString())
          .toList(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      subjects: (json['subjects'] as List<dynamic>)
          .map((subject) => subject as String)
          .toList(),
      days: (json['selectedDays'] as List<dynamic>)
          .map((day) => day as String)
          .toList(),
      hourlyRate: json['hourlyRate'] as double,
      rating: json['rating'] as double?,
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountRef': accountRef,
      'availability': availability,
      'contracts': contracts.map((contract) => contract).toList(),
      'firstName': firstName,
      'lastName': lastName,
      'subjects': subjects,
      'selectedDays': days,
      'hourlyRate': hourlyRate,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
