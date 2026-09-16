import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_security_practices/main.dart';

void main() {
  testWidgets('Menu smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SecurityPracticesApp());

    // Verify that our menu items are found.
    expect(find.text('Security Practices Demo'), findsOneWidget);
    expect(find.text('1. Secure Storage'), findsOneWidget);
  });
}
