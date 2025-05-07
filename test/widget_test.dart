// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hr_connect/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify app title and structure
    expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    expect(find.text('You have pushed the button this many times:'), findsOneWidget);
    
    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Verify the plus icon button exists
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byTooltip('Increment'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    
    // Tap the button again and verify counter increases to 2
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    
    // Verify app structure hasn't changed
    expect(find.text('You have pushed the button this many times:'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
