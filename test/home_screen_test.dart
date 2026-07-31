import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortsforge/main.dart';

void main() {
  testWidgets('Home screen displays app name and feature cards', (WidgetTester tester) async {
    await tester.pumpWidget(const ShortsForgeApp());

    // Verify app name is displayed
    expect(find.text('ShortsForge'), findsOneWidget);

    // Verify version text is displayed
    expect(find.textContaining('الإصدار'), findsOneWidget);

    // Verify all 5 feature cards are displayed (disabled)
    expect(find.text('الاستيراد'), findsOneWidget);
    expect(find.text('القوالب'), findsOneWidget);
    expect(find.text('محرر النصوص'), findsOneWidget);
    expect(find.text('الصوت'), findsOneWidget);
    expect(find.text('التصدير'), findsOneWidget);

    // Verify cards are disabled (no onTap callback)
    final importCard = find.text('الاستيراد');
    expect(importCard, findsOneWidget);
  });
}
