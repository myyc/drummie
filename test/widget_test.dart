import 'package:flutter_test/flutter_test.dart';
import 'package:drummie/main.dart';

void main() {
  testWidgets('Drummie app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const DrummieApp());
    expect(find.text('DRUMMIE'), findsOneWidget);
  });
}
