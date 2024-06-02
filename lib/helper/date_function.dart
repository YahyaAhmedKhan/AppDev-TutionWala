import 'package:cloud_firestore/cloud_firestore.dart';
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
      .map((e) => DateTimeRange(
            start: (e['startDate'] as Timestamp).toDate(),
            end: (e['endDate'] as Timestamp).toDate(),
          ))
      .toList();
  return contractRanges;
}

String formatDateRange(DateTime startDate, DateTime endDate) {
  final startDay = startDate.day;
  final startSuffix = startDay >= 11 && startDay <= 13
      ? 'th'
      : startDay % 10 == 1
          ? 'st'
          : startDay % 10 == 2
              ? 'nd'
              : startDay % 10 == 3
                  ? 'rd'
                  : 'th';
  final startMonthMap = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };
  final startMonthName = startMonthMap[startDate.month];

  final endDay = endDate.day;
  final endSuffix = endDay >= 11 && endDay <= 13
      ? 'th'
      : endDay % 10 == 1
          ? 'st'
          : endDay % 10 == 2
              ? 'nd'
              : endDay % 10 == 3
                  ? 'rd'
                  : 'th';
  final endMonthMap = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };
  final endMonthName = endMonthMap[endDate.month];

  return '${startDate.day}$startSuffix ${startMonthName} - ${endDate.day}$endSuffix ${endMonthName}';
}

String formatStartDate(DateTime startDate) {
  final day = startDate.day;
  final suffix = day >= 11 && day <= 13
      ? 'th'
      : day % 10 == 1
          ? 'st'
          : day % 10 == 2
              ? 'nd'
              : day % 10 == 3
                  ? 'rd'
                  : 'th';
  final monthMap = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };
  final monthName = monthMap[startDate.month];
  return '${startDate.day}$suffix $monthName, ${startDate.year}';
}

String formatDateTime(DateTime dateTime) {
  final formattedDate =
      '${dateTime.day}${getSuffix(dateTime.day)} ${getMonthName(dateTime.month)}';
  final formattedTime =
      '${dateTime.hour}:${pad(dateTime.minute)} ${dateTime.hour > 12 ? 'pm' : 'am'}';
  return '$formattedDate, $formattedTime';
}

String getSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  } else {
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      throw Exception('Invalid month');
  }
}

String pad(int value) {
  return value.toString().padLeft(2, '0');
}

String formatDate(DateTime dateTime) {
  String suffix;
  int day = dateTime.day;

  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }

  String month = getMonthName(dateTime
      .month); // Assuming getMonthName returns the month abbreviation (e.g., "Jan", "Feb")

  return '$day$suffix $month';
}
