import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/main.dart';

void main() {
  testWidgets('Population Chart screen loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );
    expect(find.text('Population Chart'), findsOneWidget);
  });
}
