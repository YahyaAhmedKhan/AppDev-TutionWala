import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/models/auth_state.dart';
import 'package:tution_wala/models/student.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState());

  void login(Account account) {
    state = AuthState(
        account: account,
        email: account.email,
        role: account.role,
        uid: account.id,
        isLoggedin: true);
  }

  void logout() {
    state = AuthState(isLoggedin: false);
  }
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});
