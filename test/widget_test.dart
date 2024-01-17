import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/main.dart';

void main() {
  group('Todo list smoke test', () {
    testWidgets('Add Item to Todo List', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text(''), findsNothing);

      await tester.tap(find.byIcon(Icons.add));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'AAA');

      await tester.pump();

      await tester
          .tap(find.widgetWithText(SegmentedButton<Importance>, 'Medium'));
      await tester.tap(find.byIcon(Icons.save));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsNothing);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('MEDIUM  AAA'), findsOneWidget);
      expect(find.text('!!'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));

      await tester.pump();

      await tester.drag(find.byType(Dismissible),const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('MEDIUM  AAA'), findsNothing);

    });
  });
}
