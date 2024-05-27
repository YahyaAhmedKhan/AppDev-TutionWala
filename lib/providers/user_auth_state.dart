import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/user_model.dart';

class UserAuthState extends StateNotifier<UserModel?> {
  UserAuthState() : super(null);

  void setUser(UserModel user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}

final userAuthProvider =
    StateNotifierProvider<UserAuthState, UserModel?>((ref) {
  return UserAuthState();
});
