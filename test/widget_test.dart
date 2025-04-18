//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rent_a_car/main.dart'; // Make sure this is the correct path to main.dart

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(AdminApp());

    // Just check that the login screen is present
    expect(find.text('Admin Login'), findsOneWidget);
  });
}
