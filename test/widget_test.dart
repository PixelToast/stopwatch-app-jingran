// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch_app_jingran/main.dart';

void main() {
  testWidgets('app flow', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    String getTimerText() {
      return (tester.widget<Text>(find.byKey(Key('timer.display')))).data!;
    }

    expect(
      tester.widget<ElevatedButton>(find.byKey(Key('lap.button'))).enabled,
      isFalse,
    );

    expect(
      getTimerText(),
      "00:00.0",
    );

    var startButton = find.byKey(Key("start.button"));
    await tester.tap(startButton);
    await tester.pump();

    var lapButton = find.byKey(Key("lap.button"));
    expect(
      tester.widget<ElevatedButton>(lapButton).enabled,
      isTrue,
    );

    await tester.pump(const Duration(milliseconds: 8100));

    expect(
      getTimerText(),
      "00:08.1",
    );

    await tester.tap(lapButton);
    await tester.pump();

    expect(
      find.text("Lap 1: 00:08.1"),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 3300));

    expect(
      getTimerText(),
      "00:11.4",
    );

    await tester.tap(lapButton);
    await tester.pump();

    expect(
      find.text("Lap 1: 00:08.1"),
      findsOneWidget,
    );

    expect(
      find.text("Lap 2: 00:11.4"),
      findsOneWidget,
    );

    await tester.tap(find.byKey(Key("stop.button")));
    await tester.pump();

    expect(
      tester.widget<ElevatedButton>(find.byKey(Key('lap.button'))).enabled,
      isFalse,
    );

    expect(
      getTimerText(),
      "00:00.0",
    );

    await tester.tap(startButton);
    await tester.pump();

    expect(
      find.text("Lap 2: 00:11.4"),
      findsNothing,
    );

  });
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
