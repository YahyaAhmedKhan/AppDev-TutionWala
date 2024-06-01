import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/providers/toggle_provider.dart';

// class ToggleSwitch extends StatefulWidget {
//   @override
//   _ToggleSwitchState createState() => _ToggleSwitchState();
//   late String selection;
// }

// class _ToggleSwitchState extends State<ToggleSwitch> {
//   String currValue = "Tutor";

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedToggleSwitch<String>.size(
//       textDirection: TextDirection.ltr,
//       current: currValue,
//       values: const ["Student", "Tutor"],
//       indicatorSize: const Size.fromWidth(200),
//       borderWidth: 0.0,
//       onChanged: (value) {
//         setState(() {
//           currValue = value;
//         });
//         if (currValue.contains("Student")) {
//           widget.selection = "STUDENT";
//         } else {
//           widget.selection = "TUTOR";
//         }
//       },
//       style: ToggleStyle(
//         borderColor: Colors.black,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       iconBuilder: (value) {
//         bool isSelected = value == currValue;
//         return Text(
//           value,
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontWeight: isSelected
//                 ? FontWeight.w700
//                 : FontWeight.w500, // Adjust the weights as needed
//             color: isSelected ? Colors.white : Colors.black,
//           ),
//         );
//       },
//       styleBuilder: (value) {
//         if (value == "Student") {
//           return ToggleStyle(
//             indicatorColor: Colors.green,
//             backgroundColor: Colors.grey.shade50,
//           );
//         } else {
//           return ToggleStyle(
//             indicatorColor: Colors.blue,
//             backgroundColor: Colors.grey.shade50,
//           );
//         }
//       },
//     );
//   }
// }

// // lib/toggle_switch.dart
// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'providers/toggle_provider.dart'; // Updated import path

class ToggleSwitch extends ConsumerWidget {
  double width;

  ToggleSwitch({required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current value from the provider
    // final currValue = ref.watch(toggleSwitchProvider);
    final currValue = ref.watch(toggleSwitchProvider);

    return AnimatedToggleSwitch<String>.size(
      textDirection: TextDirection.ltr,
      current: currValue,
      values: const ["Student", "Tutor"],
      // indicatorSize: const Size.fromWidth(200),
      // indicatorSize: double.infinity,
      indicatorSize: Size.fromWidth(width),
      borderWidth: 0.0,
      onChanged: (value) {
        // Update the state using the provider
        // ref.read(toggleSwitchProvider.notifier).updateSelection(value);
        ref.read(toggleSwitchProvider.notifier).updateSelection(value);
        print("new value is ${ref.read(toggleSwitchProvider)}");
      },
      style: ToggleStyle(
        borderColor: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      iconBuilder: (value) {
        bool isSelected = value == currValue;
        return Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: isSelected
                ? FontWeight.w700
                : FontWeight.w500, // Adjust the weights as needed
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      },
      styleBuilder: (value) {
        if (value == "Student") {
          return ToggleStyle(
            indicatorColor: Colors.green,
            backgroundColor: Colors.grey.shade50,
          );
        } else {
          return ToggleStyle(
            indicatorColor: Colors.blue,
            backgroundColor: Colors.grey.shade50,
          );
        }
      },
    );
  }
}
