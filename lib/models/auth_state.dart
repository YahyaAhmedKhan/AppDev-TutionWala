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

  void update({
    Account? account,
    String? email,
    String? role,
    String? uid,
    bool? isLoggedin,
  }) {
    if (account != null) this.account = account;
    if (email != null) this.email = email;
    if (role != null) this.role = role;
    if (uid != null) this.uid = uid;
    if (isLoggedin != null) this.isLoggedin = isLoggedin;
  }

  AuthState copy({
    Account? account,
    String? email,
    String? role,
    String? uid,
    bool? isLoggedin,
  }) {
    return AuthState(
      account: account ?? this.account,
      email: email ?? this.email,
      role: role ?? this.role,
      uid: uid ?? this.uid,
      isLoggedin: isLoggedin ?? this.isLoggedin,
    );
  }
}
