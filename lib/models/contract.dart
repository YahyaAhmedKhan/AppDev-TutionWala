import 'package:tution_wala/models/review.dart';

class Contract {
  final String studentRef;
  final String tutorRef;
  final int days;
  final DateTime startDate;
  final DateTime endDate;
  final String state;
  final Review? review;

  const Contract({
    required this.days,
    required this.endDate,
    this.review,
    required this.startDate,
    required this.state,
    required this.studentRef,
    required this.tutorRef,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      days: json['days'] as int,
      review: json['review'] != null
          ? Review.fromJson(json['review'] as Map<String, dynamic>)
          : null,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      state: json['state'] as String,
      studentRef: json['studentRef'] as String,
      tutorRef: json['tutorRef'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'review': review?.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'state': state,
      'studentRef': studentRef,
      'tutorRef': tutorRef,
    };
  }
}
