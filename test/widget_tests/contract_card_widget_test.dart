import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/widgets/contract_card.dart';

void main() {
  testWidgets('ContractCard renders correctly', (WidgetTester tester) async {
    // Create a Contract instance for testing
    Contract contract = Contract(
      days: 1,
      state: 'pending',
      studentRef: 'd',
      tutorRef: '',
      id: 'test_contract_id',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 7)),
      offerDate: DateTime.now(),
    );

    // Create a Tutor instance for testing
    Tutor tutor = Tutor(
      availability: '',
      contracts: [],
      subjects: ['math'],
      days: [],
      firstName: 'John',
      lastName: 'Doe',
      hourlyRate: 20.0,
    );

    // Build ContractCard widget
    await tester.pumpWidget(MaterialApp(
      home: ContractCard(
        contract: contract,
        tutor: tutor,
        handleDelete: (String id) {},
      ),
    ));

    // Verify if ContractCard renders correctly
    expect(find.text('John Doe'),
        findsOneWidget); // Assuming John Doe is displayed on the card
    expect(find.text('\$20.00/hr'),
        findsOneWidget); // Assuming hourly rate is displayed on the card
  });

  testWidgets('Delete button triggers delete action',
      (WidgetTester tester) async {
    // Create a Contract instance for testing
    Contract contract = Contract(
      days: 1,
      state: 'pending',
      studentRef: 'd',
      tutorRef: '',
      id: 'test_contract_id',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 7)),
      offerDate: DateTime.now(),
    );

    // Create a Tutor instance for testing
    Tutor tutor = Tutor(
      availability: '',
      contracts: [],
      subjects: ['math'],
      days: [],
      firstName: 'John',
      lastName: 'Doe',
      hourlyRate: 20.0,
    );

    // Variable to store if delete action is called
    bool deleteCalled = false;

    // Build ContractCard widget
    await tester.pumpWidget(MaterialApp(
      home: ContractCard(
        contract: contract,
        tutor: tutor,
        handleDelete: (String id) {
          deleteCalled = true;
        },
      ),
    ));

    // Tap on delete button
    await tester.tap(find.byIcon(Icons.delete));

    // Wait for animations to finish
    await tester.pumpAndSettle();

    // Verify if delete action is triggered
    expect(deleteCalled, true);
  });
}
