// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fake_loading_example/main.dart';

void main() {
  testWidgets('Flutter Fake Loading Demo smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app loads with the correct title.
    expect(find.text('Flutter Fake Loading'), findsOneWidget);
    expect(find.text('Welcome to Flutter Fake Loading!'), findsOneWidget);

    // Verify navigation tabs are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Basic Demo'), findsAtLeastNWidgets(1));
    expect(find.text('Overlay Demo'), findsAtLeastNWidgets(1));
    expect(find.text('Styles'), findsOneWidget);

    // Verify that the fake loader package is working
    expect(find.text('Quick Demo'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);
  });
}
