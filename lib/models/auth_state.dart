import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/models/student.dart';

class AuthState {
  String? uid;
  String? email;
  String? role;
  Account? account;
  bool isLoggedin = false;

  AuthState({
    this.uid,
    this.email,
    this.role,
    this.isLoggedin = false,
    this.account,
  });

  // factory AuthState.fromFirestore(DocumentSnapshot doc) {
  //   Map data = doc.data() as Map;
  //   return AuthState(
  //     // uid: doc.id,
  //     email: data['email'] as String,
  //     role: data['role'] as String,
  //   );
  // }
}
