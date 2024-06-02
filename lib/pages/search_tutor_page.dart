import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/providers/tutors_provider.dart';
import 'package:tution_wala/widgets/filtered_tutor_list.dart';
import 'package:tution_wala/widgets/tutor_list.dart';

class SearchTutorsPage extends StatefulWidget {
  @override
  _SearchTutorsPageState createState() => _SearchTutorsPageState();
}

class _SearchTutorsPageState extends State<SearchTutorsPage> {
  double maxRate = 50.0;
  List<String> selectedSubjects = [];
  String searchName = '';
  TextEditingController subjectsController = TextEditingController();
  List<String> allSubjects = ['Math', 'Science', 'English', 'History'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchName = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Max Rate: '),
                SizedBox(width: 10),
                // Use a TextFormField for double input
                Flexible(
                  child: TextFormField(
                    initialValue: maxRate.toString(),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        maxRate = double.tryParse(value) ?? maxRate;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Subjects: '),
                SizedBox(width: 10),
                Expanded(
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      final query = textEditingValue.text.toLowerCase();
                      return allSubjects
                          .where((subject) =>
                              subject.toLowerCase().contains(query))
                          .toList();
                    },
                    onSelected: (String selectedSubject) {
                      setState(() {
                        selectedSubjects.add(selectedSubject);
                        subjectsController.clear();
                      });
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: subjectsController,
                        focusNode: focusNode,
                        onChanged: (value) {
                          // Implement autofill logic here
                          setState(() {});
                        },
                        onSubmitted: (value) {
                          // Add submitted subject to the list of selected subjects
                          setState(() {
                            if (allSubjects.contains(value)) {
                              selectedSubjects.add(value);
                              subjectsController.clear();
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Type subject',
                        ),
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 200.0,
                            child: ListView(
                              children: options
                                  .map((String option) => ListTile(
                                        title: Text(option),
                                        onTap: () {
                                          onSelected(option);
                                        },
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    String subject = subjectsController.text.trim();
                    if (subject.isNotEmpty &&
                        !selectedSubjects.contains(subject)) {
                      setState(() {
                        selectedSubjects.add(subject);
                        subjectsController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedSubjects
                  .map(
                    (subject) => Chip(
                      label: Text(subject),
                      onDeleted: () {
                        setState(() {
                          selectedSubjects.remove(subject);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Clear all filters
                setState(() {
                  maxRate = 50.0;
                  selectedSubjects.clear();
                  searchName = '';
                });
              },
              child: Text('Clear Filters'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FilteredTutorListWidget(
                maxRate: maxRate,
                subjects: selectedSubjects,
                name: searchName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
