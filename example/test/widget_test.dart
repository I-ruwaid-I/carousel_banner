import 'package:flutter_test/flutter_test.dart';

import 'package:carousel_banner_example/main.dart';

void main() {
  testWidgets('example app renders the carousel', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Aurora'), findsOneWidget);
    expect(find.text('Soft violet light over a dark horizon.'), findsOneWidget);
  });
}
