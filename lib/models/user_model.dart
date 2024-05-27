import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  final String email;
  final String role;

  UserModel({
    // required this.uid,
    required this.email,
    required this.role,
  });
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      // uid: doc.id,
      email: data['email'] as String,
      role: data['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
    };
  }
}
