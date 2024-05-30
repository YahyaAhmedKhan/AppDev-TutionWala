import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/user-home-page.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/auth_service1.dart';
import 'package:tution_wala/service/firestore_service.dart';
import 'package:tution_wala/style/color_style.dart';

class CreateTutorAccountPage extends ConsumerStatefulWidget {
  @override
  _CreateTutorAccountPageState createState() => _CreateTutorAccountPageState();
}

class _CreateTutorAccountPageState
    extends ConsumerState<CreateTutorAccountPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  List<String> _subjects = [];
  String _availability = '';
  List<String> _selectedDays = [];
  double _hourlyRate = 0.0;

  final _subjectOptions = [
    'Math',
    'Science',
    'English'
  ]; // Add your subjects here
  final _availabilityOptions = ['Online', 'Physical', 'Hybrid'];
  final _daysOptions = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _submitForm();
      // dummyFunction();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  bool _isAsyncCallRunning = false;

  void _submitForm() async {
    // if form validation passed
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // if one availability is selected
      if (_availability.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select your availability.")));
        return;
      }

      setState(() {
        _isAsyncCallRunning = true;
      });

      FirestoreService firestoreService = FirestoreService();

      try {
        String? email = ref.read(authStateProvider).email;
        String? role = ref.read(authStateProvider).role;
        String? uid = ref.read(authStateProvider).uid;

        List<String> subjectsLowerCase =
            _subjects.map((e) => e.toLowerCase()).toList();

        List<String> daysLowerCase =
            _selectedDays.map((e) => e.toLowerCase()).toList();

        String availabilityLowerCase = _availability.toLowerCase();
        Account account = Account(email: email!, role: role!, id: uid);

        Tutor tutor = Tutor(
          availability: availabilityLowerCase,
          contracts: [],
          firstName: _firstName.trim(),
          lastName: _lastName.trim(),
          subjects: subjectsLowerCase,
          days: daysLowerCase,
          hourlyRate: double.parse(_hourlyRate.toStringAsFixed(2)),
        );

        DocumentReference accountRef =
            await firestoreService.makeTutorAccount(account, tutor);

        setState(() {
          _isAsyncCallRunning = false;
        });

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthCheckPage()));

        print("Tutor account successfully made: $accountRef");
      } catch (e) {
        print("error making account: $e");
      }
    }
  }

  Widget _buildStepIcon(int step) {
    return Icon(
      Icons.circle,
      color:
          _currentStep >= step ? Theme.of(context).primaryColor : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 255, 239),
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).size.height * 0.2),
        child: const Padding(
          child: Text(
            "Create your Tutor account",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          padding: EdgeInsets.only(top: 20, bottom: 30, left: 30, right: 30),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: _nextStep,
          onStepCancel: _previousStep,
          steps: [
            Step(
              title: const Text('Name'),
              content: Column(
                children: [
                  LabeledTextField(
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      } else if (!value.contains(RegExp(r'^[a-zA-Z\s]+$'))) {
                        return 'First name should only contain text';
                      } else if (value.length > 50) {
                        return 'First name should not exceed 50 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _firstName = value ?? '';
                    },
                  ),
                  LabeledTextField(
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      } else if (!value.contains(RegExp(r'^[a-zA-Z\s]+$'))) {
                        return 'Last name should only contain text';
                      } else if (value.length > 50) {
                        return 'Last name should not exceed 50 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _lastName = value ?? '';
                    },
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep >= 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Subjects'),
              content: Column(
                children: _subjectOptions.map((subject) {
                  return CheckboxListTile(
                    title: Text(subject),
                    value: _subjects.contains(subject),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _subjects.add(subject);
                        } else {
                          _subjects.remove(subject);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              isActive: _currentStep >= 1,
              state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('a'),
              content: Column(
                children: _availabilityOptions.map((option) {
                  return RadioListTile(
                    title: Text(option),
                    value: option,
                    groupValue: _availability,
                    onChanged: (String? value) {
                      setState(() {
                        _availability = value ?? '';
                      });
                    },
                  );
                }).toList(),
              ),
              isActive: _currentStep >= 2,
              state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Days'),
              content: Column(
                children: _daysOptions.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: _selectedDays.contains(day),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              isActive: _currentStep >= 3,
              state: _currentStep >= 3 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Rate'),
              content: Column(
                children: [
                  LabeledTextField(
                    label: 'Hourly Rate',
                    hintText: 'Enter your hourly rate',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your hourly rate';
                      } else if (double.tryParse(value) == null) {
                        return 'Invalid input. Please enter a valid number';
                      } else {
                        double hourlyRate = double.parse(value);
                        if (hourlyRate < 1 || hourlyRate > 100) {
                          return 'The rate should be between 1\$/hr - 100\$/hr';
                        }
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _hourlyRate = double.tryParse(value ?? '0.0') ?? 0.0;
                    },
                  ),
                ],
              ),
              isActive: _currentStep >= 4,
              state: _currentStep >= 4 ? StepState.complete : StepState.indexed,
            ),
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: MaterialButton(
                  //             elevation: 1,
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(17)),
                  //             color: const Color.fromARGB(255, 188, 227, 255),
                  //             // onPressed: _submitForm,
                  //             onPressed:
                  //                 _isAsyncCallRunning ? null : dummyFunction,
                  //             disabledColor: Colors.amber,
                  //             child: Padding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(vertical: 10),
                  //               child: _isAsyncCallRunning
                  //                   ? const Center(
                  //                       child: CircularProgressIndicator(),
                  //                     )
                  //                   : const Row(
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       children: [
                  //                         Text(
                  //                           "Submit",
                  //                           style: TextStyle(
                  //                               color: Colors.white,
                  //                               fontWeight: FontWeight.w700,
                  //                               fontSize: 22),
                  //                         ),
                  //                         Icon(
                  //                           Icons.chevron_right_rounded,
                  //                           color: Colors.white,
                  //                           size: 35,
                  //                         )
                  //                       ],
                  //                     ),
                  //             ))),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MaterialButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17)),
                              color: const Color.fromARGB(255, 126, 220, 4),
                              disabledColor: Color.fromARGB(255, 193, 239, 132),
                              onPressed: _isAsyncCallRunning
                                  ? null
                                  : details.onStepContinue,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: _isAsyncCallRunning
                                    ? Center(
                                        child: Transform.scale(
                                            scale: 0.5,
                                            child: CircularProgressIndicator()),
                                      )
                                    : const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Next",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 22),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.white,
                                            size: 35,
                                          )
                                        ],
                                      ),
                              ))),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MaterialButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17)),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              onPressed: details.onStepCancel,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chevron_left_rounded,
                                      color: Colors.black,
                                      size: 35,
                                    ),
                                    Text(
                                      "Go back to previous",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ))),
                    ],
                  ),
                ],
              ),
            );
          },
          stepIconBuilder: (stepIndex, stepState) {
            return _buildStepIcon(stepIndex);
          },
        ),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool obscureText;

  const LabeledTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            keyboardType: keyboardType,
            validator: validator,
            onSaved: onSaved,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
