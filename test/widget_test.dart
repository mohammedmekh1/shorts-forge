import 'package:flutter_test/flutter_test.dart';
import 'package:shortsforge/main.dart';

void main() {
  testWidgets('ShortsForge shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ShortsForgeApp());
    expect(find.text('ShortsForge'), findsOneWidget);
  });
}
