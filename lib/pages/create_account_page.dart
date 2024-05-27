import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tution_wala/pages/user-home-page.dart';
import 'package:tution_wala/style/color_style.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  List<String> _subjects = [];
  String _availability = '';

  final _subjectOptions = [
    'Math',
    'Science',
    'English'
  ]; // Add your subjects here
  final _availabilityOptions = ['Online', 'Physical', 'Hybrid'];

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await FirebaseFirestore.instance
            .collection('accounts')
            .doc(firebaseUser.uid)
            .set({
          'firstName': _firstName,
          'lastName': _lastName,
          'subjects': _subjects,
          'availability': _availability,
          'email': firebaseUser.email,
          'role': 'student', // or 'tutor', depending on your app logic
          'studentRef': '', // Update as needed
          'tutorRef': '', // Update as needed
        });

        // Navigate to the user's home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
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
      backgroundColor: Color.fromARGB(255, 236, 255, 239),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          child: Text(
            "Create your account",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          padding: EdgeInsets.only(top: 0),
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
              title: Text('Name'),
              content: Column(
                children: [
                  LabeledTextField(
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
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
              title: Text('Subjects'),
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
              title: Text('Availability'),
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
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Spacer(),

                  Row(
                    children: [
                      Expanded(
                          child: MaterialButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17)),
                              color: Color.fromARGB(255, 126, 220, 4),
                              onPressed: details.onStepContinue,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
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
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MaterialButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17)),
                              color: Color.fromARGB(255, 255, 255, 255),
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
                  // TextButton(
                  //   onPressed: details.onStepCancel,
                  //   child: Text('Back'),
                  // ),
                  // TextButton(
                  //   onPressed: details.onStepContinue,
                  //   child: Text('Next'),
                  // ),
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
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10.0),
              // ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10.0),
              //   borderSide: BorderSide(color: Colors.grey),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
