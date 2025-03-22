import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_forecasting_app/screens/homescreen.dart'; // Update with your actual app name

void main() {
  testWidgets('Sales Forecasting UI Test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    // Verify that all input fields exist
    expect(find.byType(TextField), findsNWidgets(5)); // We have 5 text fields
    expect(find.text('Predict'), findsOneWidget); // Predict button exists

    // Enter values into text fields
    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.enterText(find.byType(TextField).at(1), '500');
    await tester.enterText(find.byType(TextField).at(2), '10');
    await tester.enterText(find.byType(TextField).at(3), '2');
    await tester.enterText(find.byType(TextField).at(4), '200');

    // Tap the Predict button
    await tester.tap(find.text('Predict'));
    await tester.pump();

    // Ensure prediction result is shown
    expect(find.textContaining('Prediction:'), findsOneWidget);
  });
}
