import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('LifeTrack shell renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const LifeTrackApp());
    await tester.pumpAndSettle();

    expect(find.text('LifeTrack'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byIcon(Icons.medical_information_outlined), findsOneWidget);
  });
}
