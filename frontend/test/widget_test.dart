import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';


void main() {

  testWidgets(
    'Farmora app loads successfully',
    (WidgetTester tester) async {


      await tester.pumpWidget(
        const FarmoraApp(),
      );


      expect(
        find.byType(FarmoraApp),
        findsOneWidget,
      );


    },
  );

}