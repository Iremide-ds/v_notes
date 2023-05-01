// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:json_theme/json_theme.dart';

import 'package:v_notes/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final lightThemeStr = await rootBundle.loadString('appainter_theme.json');
    final darkThemeStr =
        await rootBundle.loadString('appainter_theme_dark.json');

    final lightThemeJson = jsonDecode(lightThemeStr);
    final darkThemeJson = jsonDecode(darkThemeStr);

    final lightTheme = ThemeDecoder.decodeThemeData(lightThemeJson);
    final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      darkTheme: darkTheme!,
      lightTheme: lightTheme!,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('No notes yet!'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
