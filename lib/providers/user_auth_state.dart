import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/my_user.dart';

class UserAuthState extends StateNotifier<MyUser?> {
  UserAuthState() : super(null);

  void setUser(MyUser user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}

final userAuthProvider = StateNotifierProvider<UserAuthState, MyUser?>((ref) {
  return UserAuthState();
});
