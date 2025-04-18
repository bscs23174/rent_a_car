import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_a_car/main.dart'; // Correct import

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(RentACarAdminApp());

    // Just check that the login screen is present
    expect(find.text('Admin Login'), findsOneWidget);
  });
}
