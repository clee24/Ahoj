import 'package:flutter_test/flutter_test.dart';
import 'package:ahoj/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AhojApp());
    expect(find.text('Ahoj'), findsOneWidget);
  });
}
