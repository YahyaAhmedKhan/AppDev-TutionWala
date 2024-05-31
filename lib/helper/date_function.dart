import 'package:flutter/material.dart';
import 'package:tution_wala/service/firestore_service.dart';

bool hasOverlap(DateTimeRange range1, DateTimeRange range2) {
  return (range1.start.isBefore(range2.end) &&
      range2.start.isBefore(range1.end));
}

Future<List<DateTimeRange>> getContractDateRanges(
    String studentId, String tutorId) async {
  final query = await FirestoreService()
      .getPendingAcceptedContractsByStudentAndTutor(studentId, tutorId);

  List<DateTimeRange> contractRanges = query.docs
      .map((e) => DateTimeRange(start: e['startDate'], end: e['endDate']))
      .toList();
  return contractRanges;
}
