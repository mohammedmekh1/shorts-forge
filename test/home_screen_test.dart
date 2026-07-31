import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortsforge/main.dart';

void main() {
  testWidgets('Home shell displays app name and feature cards', (WidgetTester tester) async {
    await tester.pumpWidget(const ShortsForgeApp());

    // Verify app name is displayed
    expect(find.text('ShortsForge'), findsOneWidget);

    // Verify version text is displayed
    expect(find.textContaining('الإصدار'), findsOneWidget);

    // Verify feature cards are displayed
    expect(find.text('الاستيراد'), findsOneWidget);
    expect(find.text('القوالب'), findsOneWidget);
    expect(find.text('محرر النصوص'), findsOneWidget);
    expect(find.text('الصوت'), findsOneWidget);
    expect(find.text('التصدير'), findsOneWidget);
  });
}
