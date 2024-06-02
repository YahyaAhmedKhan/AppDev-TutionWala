import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tution_wala/service/firestore_service.dart';

final tutorsStreamProvider = FutureProvider<Stream<QuerySnapshot>>((ref) async {
  return FirestoreService().getTutors();
});
