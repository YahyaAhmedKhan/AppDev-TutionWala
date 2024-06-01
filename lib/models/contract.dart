import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tution_wala/models/review.dart';

class Contract {
  final String studentRef;
  final String tutorRef;
  final int days;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime offerDate;
  final String state;
  final Review? review;
  String? id;

  Contract({
    required this.days,
    required this.endDate,
    this.review,
    required this.startDate,
    required this.state,
    required this.studentRef,
    required this.tutorRef,
    required this.offerDate,
    this.id,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      days: json['days'] as int,
      review: json['review'] != null
          ? Review.fromJson(json['review'] as Map<String, dynamic>)
          : null,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      offerDate: (json['offerDate'] as Timestamp).toDate(),
      state: json['state'] as String,
      studentRef: json['studentRef'] as String,
      tutorRef: json['tutorRef'] as String,
    );
  }

  factory Contract.fromFireStore(DocumentSnapshot documentSnapshot) {
    Contract contract =
        Contract.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    contract.id = documentSnapshot.id;
    return contract;
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'review': review?.toJson(),

      'startDate': Timestamp.fromDate(startDate), // Changed
      'endDate': Timestamp.fromDate(endDate), // Changed
      'offerDate': Timestamp.fromDate(offerDate),
      'state': state,
      'studentRef': studentRef,
      'tutorRef': tutorRef,
    };
  }
}
