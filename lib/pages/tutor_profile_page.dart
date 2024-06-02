import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/constants/image_paths.dart';
import 'package:tution_wala/providers/current_role_provider.dart';
import 'package:tution_wala/service/firestore_service.dart';

class TutorProfilePage extends ConsumerStatefulWidget {
  const TutorProfilePage({super.key});

  @override
  _TutorProfilePageState createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends ConsumerState<TutorProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize with empty controllers; actual values will be set in build method
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void handleSaveChanges(String tutorId, String firstName, String lastName,
      String description) async {
    try {
      setState(() {
        asyncCallRunning = true;
      });
      // await Future.delayed(Duration(seconds: 2));
      // throw Exception("Coulndt save");

      await FirestoreService()
          .updateTutorInformation(tutorId, firstName, lastName, description);
      ref.refresh(tutorProvider);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Changes saved,")));
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Could not save changes at this time.")));
    } finally {
      setState(() {
        asyncCallRunning = false;
      });
    }
  }

  bool asyncCallRunning = false;

  @override
  Widget build(BuildContext context) {
    final asyncValueTutor = ref.watch(tutorProvider);

    return asyncValueTutor.when(
      data: (tutor) {
        // Set the initial values for the controllers
        firstNameController.text = tutor.firstName;
        lastNameController.text = tutor.lastName;
        descriptionController.text = tutor.description ?? "";

        print(tutor.description);

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              tutor.imageUrl ?? boyPics[Random().nextInt(4)],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                // Add functionality to change profile picture
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text("Edit Profile",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("First Name",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Last Name",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Description",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                      decoration: const InputDecoration(
                        hintText:
                            "Add a description so Student can get to know you.",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        handleSaveChanges(
                            tutor.id!,
                            firstNameController.text,
                            lastNameController.text,
                            descriptionController.text);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: asyncCallRunning
                                ? const Color.fromARGB(255, 49, 49, 49)
                                : Colors.black,
                            borderRadius: BorderRadius.circular(14)),
                        child: SizedBox(
                          height: 60,
                          child: Center(
                            child: asyncCallRunning
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Saving...",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Transform.scale(
                                        scale: 0.7,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    "Save changes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text(error.toString()),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
