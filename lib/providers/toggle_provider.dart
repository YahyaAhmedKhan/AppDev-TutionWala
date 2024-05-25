import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a StateNotifier to manage the state of the toggle switch
class ToggleSwitchNotifier extends StateNotifier<String> {
  ToggleSwitchNotifier() : super('Tutor'); // Initial state

  void updateSelection(String newValue) {
    state = newValue;
  }
}

// Create a provider for the ToggleSwitchNotifier
final toggleSwitchProvider =
    StateNotifierProvider<ToggleSwitchNotifier, String>((ref) {
  return ToggleSwitchNotifier();
});
