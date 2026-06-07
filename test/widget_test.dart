import 'package:flutter_test/flutter_test.dart';
import 'package:yojanalabh/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const YojanaLabhApp());
    expect(find.text('योजनालाभ'), findsOneWidget);
  });
}
